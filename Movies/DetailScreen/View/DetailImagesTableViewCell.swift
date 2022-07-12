//
//  DetailImagesTableViewCell.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 07.07.2022.
//

import Foundation
import UIKit

final class DetailImagesTableViewCell: UITableViewCell {
    
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        
        return scrollView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func config(with images: [UIImage?]) {
        if images.isEmpty { return }
        
        scrollView.contentSize = CGSize(
            width: contentView.bounds.width * CGFloat(images.count),
            height: contentView.bounds.height
        )
        
        let imagesForScroll = images.map { UIImageView(image: $0) }
        
        for index in 0..<images.count {
            imagesForScroll[index].layer.masksToBounds = true
            imagesForScroll[index].contentMode = .scaleAspectFill
            scrollView.addSubview(imagesForScroll[index])
            
            if index == 0 {
                imagesForScroll[index].anchor(top: scrollView.topAnchor,
                                              leading: scrollView.leadingAnchor,
                                              width: contentView.bounds.width,
                                              height: scrollView.contentSize.height)
            }
            else {
                imagesForScroll[index].anchor(top: scrollView.topAnchor,
                                              leading: imagesForScroll[index-1].trailingAnchor,
                                              width: contentView.bounds.width,
                                              height: scrollView.contentSize.height)
            }
        }
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        
        scrollView.alwaysBounceHorizontal = true
        scrollView.anchor(top: contentView.topAnchor,
                          bottom: contentView.bottomAnchor,
                          leading: contentView.leadingAnchor,
                          trailing: contentView.trailingAnchor,
                          height: 400)
    }
}
