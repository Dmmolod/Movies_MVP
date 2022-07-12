//
//  NetworkError.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 04.07.2022.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case imageNotFound
    case filmsNotFound
    
    var errorDescription: String? {
        switch self {
        case .imageNotFound:
            return "Image not found"
        case .filmsNotFound:
           return "Films not found"
        }
    }
}
