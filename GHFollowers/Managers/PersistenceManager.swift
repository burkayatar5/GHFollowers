//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Burkay Atar on 22.01.2024.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (GHError?) -> Void) {
        retrieveFavorites { result in
            switch result {
                case .success(var favorites):

                    switch actionType {
                        case .add:
                            guard !favorites.contains(favorite) else { completion(.alreadyInFavorites); return }
                            favorites.append(favorite)
                                    
                        case .remove:
                            favorites.removeAll { $0.login == favorite.login }
                    }
                    
                    completion(saveFavorites(favorites: favorites))
                
                case .failure(let error):
                    completion(error)
            }
        }
    }
    
    /// Retrieving favorites data from UserDefaults
    /// - Parameter completion: Returns a Follower object array on success or custom GHError on failure
    static func retrieveFavorites(completion: @escaping (Result<[Follower], GHError>) -> Void) {
        /// try to get the data with given key
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            /// this means user have not add any favorites yet, i do not consider this as a failure case so it returns an empty array.
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    /// Save given favorites list to the user defaults
    /// - Parameter favorites: follower list that user favorited
    /// - Returns: An optional GHError, nil on success and selected GHError for this case on failure.
    static func saveFavorites(favorites: [Follower]) -> GHError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
