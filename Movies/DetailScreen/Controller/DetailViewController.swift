//
//  DetailViewController.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 05.07.2022.
//

import Foundation
import UIKit

enum DetailTableViewCellsType: CaseIterable {
    case imagesCell, overviewCell
}

class DetailViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    private let detailView = DetailView()
    private let film: Film
    
    private var images = [UIImage?]()
    private var imagesPathList = [FilmImage]() {
        didSet {
            getImages()
        }
    }

    
    init(film: Film) {
        self.film = film
        super.init(nibName: nil, bundle: nil)
        title = film.title
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = detailView
        detailView.delegate = self
        getImagesList()
    }
    
    private func getImagesList() {
        
        networkManager.getImages(for: String(film.id)) { result in
            switch result {
            case .success(let filmImagesList): self.imagesPathList = filmImagesList.backdrops
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    private func getImages() {
        let imagesGroup = DispatchGroup()
        
        for imageIndex in 0..<(imagesPathList.count > 10 ? 10 : imagesPathList.count) {
            imagesGroup.enter()
            
            networkManager.getImage(by: imagesPathList[imageIndex].filePath) { result in
                switch result {
                case .success(let image): self.images.append(image)
                case .failure(let error): print(error.localizedDescription)
                }
                imagesGroup.leave()
            }
        }
        
        imagesGroup.notify(queue: .main) {
            self.detailView.reloadRows(
                at: [IndexPath(row: DetailTableViewCellsType.allCases.firstIndex(of: .imagesCell)!,
                               section: 0)])
        }
    }
    
}

extension DetailViewController: DetailTableViewDelegate {
    func detailTableViewDelegate() -> UITableViewDelegate { self }
    
    func detailTableViewDataSource() -> UITableViewDataSource { self }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DetailTableViewCellsType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell?
        
        switch DetailTableViewCellsType.allCases[indexPath.row] {
            
        case .imagesCell:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: DetailImagesTableViewCell.identifier,
                                                         for: indexPath) as? DetailImagesTableViewCell
            
            tempCell?.config(with: images)
            cell = tempCell
            
        case .overviewCell:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: DetailOverviewTableViewCell.identifier,
                                                         for: indexPath) as? DetailOverviewTableViewCell
            
            tempCell?.config(overviewText: "   " + film.overview)
            cell = tempCell
        }
        
        guard let cell = cell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch DetailTableViewCellsType.allCases[indexPath.row] {
        case .imagesCell: return 400
        default: return UITableView.automaticDimension
        }
    }
    
    
}
