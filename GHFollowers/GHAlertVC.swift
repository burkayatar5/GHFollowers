//
//  GHAlertVC.swift
//  GHFollowers
//
//  Created by Burkay Atar on 1.01.2024.
//

import UIKit

class GHAlertVC: UIViewController {

    let containerView: UIView = UIView()
    let titleLabel: GHTitleLabel = GHTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel: GHBodyLabel = GHBodyLabel(textAlignment: .center)
    let actionButton: GHButton = GHButton(backgroundColor: .systemPink, title: "Ok")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
