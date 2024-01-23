//
//  GHFollowerItemVC.swift
//  GHFollowers
//
//  Created by Burkay Atar on 22.01.2024.
//

import UIKit

class GHFollowerItemVC: GHItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        guard let user = user else { return }
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        guard let user = user else { return }
        delegate?.didTapGetFollowers(for: user)
    }

}
