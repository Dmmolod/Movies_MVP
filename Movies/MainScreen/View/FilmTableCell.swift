//
//  FilmTableCell.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 04.07.2022.
//

import Foundation
import UIKit

final class FilmTableCell: UITableViewCell {
    
    let poster = UIImageView()
    let titleLable = UILabel(), overviewLable = UILabel()
    let voteAverageLable = UILabel()
    let releaseDateLable = UILabel()
    
    private var posterPath: String? {
        didSet {
            poster.image = nil
            loadPoster()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    
    func config(posterPath: String,
                title: String,
                overview: String,
                voteAverage: String,
                releaseDate: String?) {
        
        self.posterPath = posterPath
        titleLable.text = title
        overviewLable.text = overview
        voteAverageLable.text = voteAverage
        releaseDateLable.text = releaseDate
    }
    
    private func loadPoster() {
        if let posterPath = posterPath {
            NetworkManager().getImage(by: posterPath) { [weak self] result in
                switch result {
                case .success(let poster):
                    if posterPath == self?.posterPath {
                        self?.poster.image = poster
                    }
                case .failure(let error): print("\(String(describing: self)): \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func setupUI() {
        [poster, titleLable, overviewLable, voteAverageLable, releaseDateLable].forEach { contentView.addSubview($0) }
        
        poster.layer.cornerRadius = 10
        poster.contentMode = .scaleAspectFill
        poster.clipsToBounds = true
        poster.anchor(top: contentView.topAnchor,
                      bottom: contentView.bottomAnchor,
                      leading: contentView.leadingAnchor,
                      paddingTop: 3,
                      paddingBottom: 3,
                      paddingLeading: 5,
                      width: contentView.frame.width/2.3)
        
        titleLable.textAlignment = .center
        titleLable.numberOfLines = 2
        titleLable.adjustsFontSizeToFitWidth = true
        titleLable.font = .systemFont(ofSize: 15, weight: .heavy)
        titleLable.anchor(top: poster.topAnchor,
                          leading: poster.trailingAnchor,
                          trailing: contentView.trailingAnchor,
                          paddingLeading: 5,
                          paddingTrailing: 5,
                          height: 25)
        
        releaseDateLable.font = .systemFont(ofSize: 10, weight: .light)
        releaseDateLable.anchor(top: titleLable.bottomAnchor,
                                leading: titleLable.leadingAnchor,
                                paddingTop: 10,
                                height: 20)
        
        voteAverageLable.font = .italicSystemFont(ofSize: 13)
        voteAverageLable.anchor(bottom: poster.bottomAnchor,
                                trailing: titleLable.trailingAnchor,
                                paddingBottom: 10,
                                height: 20)
        
        overviewLable.numberOfLines = 0
        overviewLable.textAlignment = .left
        overviewLable.font = .systemFont(ofSize: 12, weight: .thin)
        overviewLable.anchor(top: releaseDateLable.bottomAnchor,
                             bottom: voteAverageLable.topAnchor,
                             leading: titleLable.leadingAnchor,
                             trailing: titleLable.trailingAnchor,
                             paddingTop: 5,
                             paddingBottom: 5)
    }
    
}
