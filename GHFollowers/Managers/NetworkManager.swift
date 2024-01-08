//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Burkay Atar on 4.01.2024.
//

import UIKit


class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.github.com"
    ///cache images so you dont need to download images every time you scrool on app
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getFollowers(for username: String,
                      page: Int,
                      completion: @escaping (Result<[Follower], GHError>) -> Void) {
        let endpoint = baseURL + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try jsonDecoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
            
            
        }
        task.resume()
    }
    
    
}
