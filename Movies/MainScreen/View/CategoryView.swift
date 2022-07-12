//
//  CategoryView.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 04.07.2022.
//

import Foundation
import UIKit

protocol CategoryViewDelegate: AnyObject {
    func setupCollectionViewDelegate() -> UICollectionViewDelegate
    func setupCollectionViewDataSource() -> UICollectionViewDataSource

}

final class CategoryView: UIView {
    
    weak var delegate: CategoryViewDelegate? {
        didSet {
            setupDelegate()
        }
    }
    
    private var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 150, height: 30)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.showsHorizontalScrollIndicator = false
        collection.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
        
        return collection
    }()
    
    override func layoutSubviews() {
        backgroundColor = .systemBackground
        addSubview(categoryCollectionView)
        
        categoryCollectionView.anchor(top: topAnchor,
                                      bottom: bottomAnchor,
                                      leading: leadingAnchor,
                                      trailing: trailingAnchor,
                                      paddingLeading: 10,
                                      paddingTrailing: 10)
    }
    
    func selectItem(i: Int?) {
        guard let i = i else { return }
        
        let indexPath = IndexPath(item: i, section: 0)

        categoryCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)        
    }
    
    private func setupDelegate() {
        categoryCollectionView.dataSource = delegate?.setupCollectionViewDataSource()
        categoryCollectionView.delegate = delegate?.setupCollectionViewDelegate()
    }
}
