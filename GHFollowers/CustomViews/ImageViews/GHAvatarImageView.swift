//
//  GHAvatarImageView.swift
//  GHFollowers
//
//  Created by Burkay Atar on 4.01.2024.
//

import UIKit

class GHAvatarImageView: UIImageView {

    let cache = NetworkManager.shared.cache
    let placeHolderImage = Images.placeHolder
    
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
}
