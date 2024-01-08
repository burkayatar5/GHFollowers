//
//  GHAvatarImageView.swift
//  GHFollowers
//
//  Created by Burkay Atar on 4.01.2024.
//

import UIKit

class GHAvatarImageView: UIImageView {

    let cache = NetworkManager.shared.cache
    let placeHolderImage = UIImage(named: "avatar-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    ///We do not handle image downloanding errors because if something goes wrong we have our placeholder image, it indicates there is a problem.
    func downloadImage(from urlString: String) {
        
        let cacheKey = NSString(string: urlString)
        ///our cache key is the urlString because it is unique for every follower.
        ///if we have our image in cache use it directly and return.
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        ///if we dont have the image in cache download it and put it in cache for later use.
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
