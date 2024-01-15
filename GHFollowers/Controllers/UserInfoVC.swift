//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Burkay Atar on 9.01.2024.
//

import UIKit

class UserInfoVC: UIViewController {

    let headerView = UIView()
    
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        layoutUI()
        
        guard let username = username else { return }
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.add(childVC: GHUserInfoHeaderVC(user: user), to: self.headerView)
                    }

                case .failure(let error):
                    self.presentGHAlertOnMainThread(title: "Something went wrong",
                                                    message: error.rawValue,
                                                    buttonTitle: "Ok")
            }
        }
    }
    
    private func layoutUI() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
