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
    private let presenter: MainViewPresenter
    
    let filmsTable = UITableView()
    let categoryView = CategoryView()


    init(with presenter: MainViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.delegate = self
        categoryView.delegate = self
    }
    
    required init?(coder: NSCoder) { return nil }
    
    deinit { print("\(String(describing: self)): Deinit") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        categoryView.selectItem(i: presenter.currentCategoryIndex)

        setupUI()
        setupFilmTable()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
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
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard presenter.films.count > indexPath.row,
              let filmCell = tableView.dequeueReusableCell(withIdentifier: FilmTableCell.identifier,
                                                       for: indexPath) as? FilmTableCell else { return UITableViewCell() }
        
        let filmForCell = presenter.films[indexPath.row]
        
        filmCell.config(posterPath: filmForCell.poster_path,
                        title: filmForCell.title,
                        overview: "   " + filmForCell.overview,
                        voteAverage: String(filmForCell.vote_average),
                        releaseDate: filmForCell.releaseDate)
        
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
        presenter.didSelectFilm(cell: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter.filmTableDidScroll(
            contentOffset: scrollView.contentOffset,
            frame: scrollView.frame,
            contentSize: scrollView.contentSize)
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
        
        let category = presenter.category(to: indexPath.item)
        categoryCell.config(text: category.nameForView)
        
        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        presenter.didSelectCategory(cell: indexPath.item)
    }
}

extension MainViewController: MainViewPresenterDelegate {
    
    func mainViewPresenterModelUpdate() {
        filmsTable.reloadData()
    }
    
    func mainViewPresenterDidSelect(film: Film) {
        appNavigation?.goToDetailView(with: film)
    }
    
    func mainViewPresenterDidSelectCategory() {
        let firstFilmTableCellIndexPath = IndexPath(row: 0, section: 0)
        
        if !filmsTable.visibleCells.isEmpty {
            filmsTable.scrollToRow(at: firstFilmTableCellIndexPath, at: .top, animated: true)
        }
    }
}
