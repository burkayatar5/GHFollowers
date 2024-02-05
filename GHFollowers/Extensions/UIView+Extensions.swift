//
//  UIView+Extensions.swift
//  GHFollowers
//
//  Created by Burkay Atar on 5.02.2024.
//

import UIKit

extension UIView {
    
    func pinToEdges(of superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
    
    /// Add subviews in one line
    /// - Parameter views: UIView elements in code
    func addSubViews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
