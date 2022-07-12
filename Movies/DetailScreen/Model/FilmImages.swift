//
//  FilmImages.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 07.07.2022.
//

import Foundation

struct FilmImage: Decodable {
    let filePath: String
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

struct FilmImagesResponse: Decodable {
    let backdrops: [FilmImage]
}
