//
//  DetailViewController.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 05.07.2022.
//

import Foundation
import UIKit

final class DetailViewController: UIViewController {
    
    private let presenter: DetailViewPresenter
    private let detailView = DetailView()
    
    init(with presenter: DetailViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = detailView
        detailView.delegate = self
    }
}

extension DetailViewController: DetailTableViewDelegate {
    func detailTableViewDelegate() -> UITableViewDelegate { self }
    
    func detailTableViewDataSource() -> UITableViewDataSource { self }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.detailCellsType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell?
        
        switch presenter.detailCellsType[indexPath.row] {
            
        case .imagesCell:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: DetailImagesTableViewCell.identifier,
                                                         for: indexPath) as? DetailImagesTableViewCell
            
            tempCell?.config(with: presenter.images)
            cell = tempCell
            
        case .overviewCell:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: DetailOverviewTableViewCell.identifier,
                                                         for: indexPath) as? DetailOverviewTableViewCell
            
            tempCell?.config(overviewText: "   " + presenter.film.overview )
            cell = tempCell
        }
        
        guard let cell = cell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch presenter.detailCellsType[indexPath.row] {
        case .imagesCell: return 400
        default: return UITableView.automaticDimension
        }
    }
}

extension DetailViewController: DetailViewPresenterDelegate {
    func detailViewPresenterDidGetImages() {
        detailView.reloadRows(
            at: [IndexPath(row: DetailTableViewCellsType.allCases.firstIndex(of: .imagesCell)!,
                           section: 0)])
    }
}
