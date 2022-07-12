//
//  MainViewPresenter.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 12.07.2022.
//

import Foundation
import UIKit

protocol MainViewPresenterDelegate: AnyObject {
    func mainViewPresenterModelUpdate()
    func mainViewPresenterDidSelect(film: Film)
    func mainViewPresenterDidSelectCategory()
}

final class MainViewPresenter {
    
    weak var delegate: MainViewPresenterDelegate?
    
    private let networkManager = NetworkManager()
    
    var currentCategory: FilmCategory = .topRated
    var currentFilmsResponse: FilmsResponse?
    var films = [Film]()
    var isPaging = true
    var currentCategoryIndex: Int? {
        return FilmCategory.allCases.firstIndex(of: currentCategory)
    }
    
    init() {
        getFilms(page: nil)
    }
    
    deinit { print("\(String(describing: self)): Deinit") }
    
    func category(to index: Int) -> FilmCategory {
        guard FilmCategory.allCases.count > index else { return currentCategory }
        return FilmCategory.allCases[index]
    }
    
    func filmTableDidScroll(contentOffset: CGPoint,
                            frame: CGRect,
                            contentSize: CGSize) {
        
        let scrollHeight = frame.size.height + contentOffset.y
        
        guard scrollHeight > contentSize.height && isPaging,
              let currentFilmsResponse = currentFilmsResponse,
              currentFilmsResponse.page < currentFilmsResponse.total_pages  else { return }
        
        isPaging = false
        getFilms(page: currentFilmsResponse.page + 1) { self.isPaging = true }
    }
    
    func didSelectFilm(cell index: Int) {
        guard films.count > index  else { return }
        let film = films[index]
        delegate?.mainViewPresenterDidSelect(film: film)
    }
    
    func didSelectCategory(cell index: Int) {
        films.removeAll()
        currentCategory = FilmCategory.allCases[index]
        getFilms(page: nil)
        delegate?.mainViewPresenterDidSelectCategory()
    }
    
    private func getFilms(page: Int?, completion: (() -> Void)? = nil) {
        
        networkManager.getFilms(page: page, category: currentCategory) { [unowned self] result in
            switch result {
            case .success(let filmsResponse):
                self.currentFilmsResponse = filmsResponse
                self.films.append(contentsOf: filmsResponse.results)
                self.isPaging = true
                self.delegate?.mainViewPresenterModelUpdate()
                
            case .failure(let error): print(self.currentCategory.nameForView, " for page - \(page ?? -1): ",error.localizedDescription, separator: "")
            }
        }
    }
}
