//
//  MainViewController.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 04.07.2022.
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
    
    weak var appNavigation: AppNavigation?
    
    let filmsTable = UITableView()
    let networkManager = NetworkManager()
    let categoryView = CategoryView()

    var currentCategory: FilmCategory = .topRated
    var films = [Film]()
    var currentFilmsResponse: FilmsResponse?
    var isPaging = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Movies"
               
        categoryView.delegate = self
        categoryView.selectItem(i: FilmCategory.allCases.firstIndex(of: currentCategory))

        setupUI()
        setupFilmTable()
        getFilms(page: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(filmsTable)
        filmsTable.anchor(top: view.topAnchor,
                          bottom: view.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
    }
    
    private func setupFilmTable() {
        filmsTable.delegate = self
        filmsTable.dataSource = self
        filmsTable.register(FilmTableCell.self, forCellReuseIdentifier: FilmTableCell.identifier)
    }
    
    private func getFilms(page: Int?, completion: (() -> Void)? = nil) {
        networkManager.getFilms(page: page, category: currentCategory) { [weak self] result in
            switch result {
            case .success(let filmsResponse):
                self?.currentFilmsResponse = filmsResponse
                self?.films.append(contentsOf: filmsResponse.results)
                self?.filmsTable.reloadData()
                completion?()
                
                case .failure(let error): print(self?.currentCategory.nameForView ?? "", " for page - \(page ?? 1): ",error.localizedDescription, separator: "")
            }
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard films.count > indexPath.row,
              let filmCell = tableView.dequeueReusableCell(withIdentifier: FilmTableCell.identifier,
                                                       for: indexPath) as? FilmTableCell else { return UITableViewCell() }
        
        let filmForCell = films[indexPath.row]
        let releaseDate = DateFormatter().stringDate(from: filmForCell.release_date,
                                                     currentFormat: "YY-MM-dd",
                                                     to: "dd.MM.YYYY")
        
        filmCell.config(posterPath: filmForCell.poster_path,
                        title: filmForCell.title,
                        overview: "   " + filmForCell.overview,
                        voteAverage: String(filmForCell.vote_average),
                        releaseDate: releaseDate)
        
        return filmCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return categoryView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard films.count > indexPath.row  else { return }
        let film = films[indexPath.row]
        appNavigation?.goToDetailView(with: film)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard (scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height && isPaging,
              let currentFilmsResponse = currentFilmsResponse,
              currentFilmsResponse.page < currentFilmsResponse.total_pages  else { return }
        
        isPaging = false
        getFilms(page: currentFilmsResponse.page + 1, completion: {
            self.isPaging = true
        })
    }
    
}

extension MainViewController: CategoryViewDelegate {
    func setupCollectionViewDelegate() -> UICollectionViewDelegate {
        self
    }
    
    func setupCollectionViewDataSource() -> UICollectionViewDataSource {
        self
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FilmCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier,
                                                      for: indexPath) as? CategoryCollectionCell else { return UICollectionViewCell() }
        
        let filmCategory = FilmCategory.allCases[indexPath.item]
        categoryCell.config(text: filmCategory.nameForView)
        
        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        films.removeAll()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        let firstFilmCellIndexPath = IndexPath(row: 0, section: 0)
        
        if !filmsTable.visibleCells.isEmpty {
            filmsTable.scrollToRow(at: firstFilmCellIndexPath, at: .top, animated: true)
        }
        
        currentCategory = FilmCategory.allCases[indexPath.item]
        getFilms(page: nil)
    }
    
}
