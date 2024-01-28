//
//  UIViewController+Extension.swift
//  GHFollowers
//
//  Created by Burkay Atar on 2.01.2024.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView?

extension UIViewController {
    //MARK: - AlertView methods
    func presentGHAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GHAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Present Safari View Controller method
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
}
