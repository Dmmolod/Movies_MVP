//
//  DetailViewPresenter.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 12.07.2022.
//

import Foundation
import UIKit

protocol DetailViewPresenterDelegate: AnyObject {
    func detailViewPresenterDidGetImages()
}

class DetailViewPresenter {
    
    // MARK: - Public Properties
    
    weak var delegate: DetailViewPresenterDelegate? {
        didSet {
            getImagesResponseArray()
        }
    }
    
    var detailCellsType = DetailTableViewCellsType.allCases
    var images = [UIImage?]()
    let film: Film

    // MARK: - Private Properties
    
    private var imagesResponseArray = [FilmImage]() {
        didSet {
            getImages()
        }
    }
    
    private let networkManager = NetworkManager()
    
    // MARK: - Initializers
    
    init(with film: Film) {
        self.film = film
    }
    
    // MARK: - Public Methods
    
    
    // MARK: - Private Methods
    
    private func getImages() {
        let imagesGroup = DispatchGroup()
        
        for imageIndex in 0..<(imagesResponseArray.count > 10 ? 10 : imagesResponseArray.count) {
            imagesGroup.enter()
            
            networkManager.getImage(by: imagesResponseArray[imageIndex].filePath) { [unowned self] result in
                switch result {
                case .success(let image): self.images.append(image)
                case .failure(let error): print(error.localizedDescription)
                }
                imagesGroup.leave()
            }
        }
        
        imagesGroup.notify(queue: .main) { [weak self] in
            self?.delegate?.detailViewPresenterDidGetImages()
        }
    }
    
    private func getImagesResponseArray() {
        
        networkManager.getImages(for: String(film.id)) { [unowned self] result in
            switch result {
            case .success(let filmImagesResponseArray): self.imagesResponseArray = filmImagesResponseArray.backdrops
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
}
