//
//  DetailView.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 07.07.2022.
//

import Foundation
import UIKit

protocol DetailTableViewDelegate: AnyObject {
    func detailTableViewDataSource() -> UITableViewDataSource
    func detailTableViewDelegate() -> UITableViewDelegate
}

final class DetailView: UIView {
    
    weak var delegate: DetailTableViewDelegate? {
        didSet {
            setupDelegate()
        }
    }
    
    private let detailTableView = UITableView()
        
   init() {
       super.init(frame: .zero)
        
       setupUI()
       registerCells()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func reloadRows(at indexPath: [IndexPath]) {
        detailTableView.reloadRows(at: indexPath, with: .none)
    }
    
    private func setupUI() {
        addSubview(detailTableView)
        
        detailTableView.separatorStyle = .none
        detailTableView.anchor(top: topAnchor,
                               bottom: bottomAnchor,
                               leading: leadingAnchor,
                               trailing: trailingAnchor)
    }
    
    private func registerCells() {
        detailTableView.register(DetailImagesTableViewCell.self, forCellReuseIdentifier: DetailImagesTableViewCell.identifier)
        detailTableView.register(DetailOverviewTableViewCell.self, forCellReuseIdentifier: DetailOverviewTableViewCell.identifier)
    }
    
    private func setupDelegate() {
        detailTableView.delegate = delegate?.detailTableViewDelegate()
        detailTableView.dataSource = delegate?.detailTableViewDataSource()
    }
}
