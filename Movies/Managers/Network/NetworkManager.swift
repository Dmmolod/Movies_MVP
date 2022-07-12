//
//  NetworkManager.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 04.07.2022.
//

import Foundation
import UIKit

final class NetworkManager {
    
    private let baseUrl = "https://api.themoviedb.org/3/movie/", key = "api_key=6b17d488280ac0859560482490d1f60d", language = "language=ru"
    private let baseImageUrl = "https://image.tmdb.org/t/p/original"
        
    func getFilms(page: Int?, category: FilmCategory, _ completion: @escaping (Result<FilmsResponse, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + category.rawValue + "?" + key + "&" + language + (page != nil ? "&page=\(page!)" : "")) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
            let filmsResponse = try? JSONDecoder().decode(FilmsResponse.self, from: data) else {
                
                completion(.failure(NetworkError.filmsNotFound))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(filmsResponse))
            }
        }.resume()
    }
    
    func getImages(for id: String, _ completion: @escaping (Result<FilmImagesResponse, Error>) -> Void) {
        guard let url = URL(string: baseUrl + id + "/images" + "?\(key)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  error == nil,
                  let filmImagesResponse = try? JSONDecoder().decode(FilmImagesResponse.self, from: data) else { return }

            completion(.success(filmImagesResponse))
        }.resume()
    }
    
    func getImage(by path: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: self.baseImageUrl + path),
                  let imageData = try? Data(contentsOf: url),
                  let image = UIImage(data: imageData) else {
                completion(.failure(NetworkError.filmsNotFound))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
    }
}
