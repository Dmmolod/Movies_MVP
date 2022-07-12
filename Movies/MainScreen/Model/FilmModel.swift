//
//  FilmModel.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 04.07.2022.
//

import Foundation

enum FilmCategory: String, CaseIterable {
    case topRated = "top_rated", popular = "popular", nowPlaying = "now_playing", upcoming
    
    var nameForView: String {
        switch self {
        case .topRated: return "Топ"
        case .popular: return "Популярное"
        case .nowPlaying: return "Сейчас в кино"
        case .upcoming: return "Скоро в кино"
        }
    }
}

struct FilmsResponse: Decodable {
    let page: Int
    let results: [Film]
    let total_pages: Int
}

struct Film: Decodable {
    let id: Int
    let title, overview: String
    let vote_average: Double
    let poster_path: String
    let release_date: String
}
