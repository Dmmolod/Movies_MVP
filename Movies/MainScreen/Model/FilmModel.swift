//
//  FilmModel.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 04.07.2022.
//

import Foundation

struct FilmsResponse: Decodable {
    let page: Int
    let results: [Film]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

struct Film: Decodable {
    
    private let _releaseDate: String
    var releaseDate: String? {
        return DateFormatter().stringDate(from: _releaseDate, currentFormat: "YY-MM-dd", to: "dd.MM.YYYY")
    }
    let id: Int
    let title, overview: String
    let voteAverage: Double
    let posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case id ,title, overview
        case _releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        
    }
}
