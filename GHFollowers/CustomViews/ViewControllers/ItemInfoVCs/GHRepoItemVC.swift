//
//  GHRepoItemVC.swift
//  GHFollowers
//
//  Created by Burkay Atar on 22.01.2024.
//

import UIKit

class GHRepoItemVC: GHItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        guard let user = user else { return }
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        guard let user = user else { return }
        delegate?.didTapGitHubProfile(for: user)
    }
}
