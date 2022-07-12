//
//  FilmCategoryTypes.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 12.07.2022.
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
