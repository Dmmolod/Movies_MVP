//
//  DetailOverviewTableViewCell.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 07.07.2022.
//

import Foundation
import UIKit

class DetailOverviewTableViewCell: UITableViewCell {
    
    private var overviewLable: UILabel = {
       let lab = UILabel()
        lab.numberOfLines = 0
        lab.textAlignment = .left
        
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func config(overviewText: String) {
        overviewLable.text = overviewText
    }
    
    private func setupUI() {
        contentView.addSubview(overviewLable)
        selectionStyle = .none
        
        overviewLable.anchor(top: contentView.topAnchor,
                             bottom: contentView.bottomAnchor,
                             leading: contentView.leadingAnchor,
                             trailing: contentView.trailingAnchor,
                             paddingTop: 10,
                             paddingLeading: 5,
                             paddingTrailing: 5)
    }
}
