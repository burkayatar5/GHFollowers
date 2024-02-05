//
//  GHRepoItemVC.swift
//  GHFollowers
//
//  Created by Burkay Atar on 22.01.2024.
//

import UIKit

protocol GHRepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

class GHRepoItemVC: GHItemInfoVC {
    
    weak var delegate: GHRepoItemVCDelegate?
    
    init(user: User, delegate: GHRepoItemVCDelegate?) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
