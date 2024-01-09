//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Burkay Atar on 9.01.2024.
//

import UIKit

class UserInfoVC: UIViewController {

    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        guard let username = username else { return }
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    print(user)
                case .failure(let error):
                    self.presentGHAlertOnMainThread(title: "Something went wrong",
                                                    message: error.rawValue,
                                                    buttonTitle: "Ok")
            }
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
