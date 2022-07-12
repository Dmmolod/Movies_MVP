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
    let total_pages: Int
}

struct Film: Decodable {
    
    private let release_date: String
    var releaseDate: String? {
        return DateFormatter().stringDate(from: release_date, currentFormat: "YY-MM-dd", to: "dd.MM.YYYY")
    }
    let id: Int
    let title, overview: String
    let vote_average: Double
    let poster_path: String
}
