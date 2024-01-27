//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Burkay Atar on 30.12.2023.
//

//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTextField = GHTextField()
    let getFollowersButton = GHButton(backgroundColor: .systemGreen, title: "Get Followers")
    weak var logoImageViewTopConstraint: NSLayoutConstraint?
    
    var isUsernameEntered: Bool {
        if let usernameText = usernameTextField.text?.isEmpty {
            return !usernameText
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureUsernameTextField()
        configureGetFollowersButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///hide navigation bar in viewWillAppear because this method triggers every time view will appear unlike viewDidLoad.
        navigationController?.setNavigationBarHidden(true, animated: true)
        usernameTextField.text = ""
        
    }
    
    /// Dismiss keyboard when user tap anywhere on screen after end editing text field.
    private func createDismissKeyboardTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentGHAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for.", buttonTitle: "Ok")
            return
        }
        
        usernameTextField.resignFirstResponder()
        
        let followerListVC = FollowerListVC(username: usernameTextField.text!)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        logoImageViewTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureUsernameTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureGetFollowersButton() {
        view.addSubview(getFollowersButton)
        getFollowersButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            getFollowersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            getFollowersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            getFollowersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            getFollowersButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//MARK: - UITextFieldDelegate methods
extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
