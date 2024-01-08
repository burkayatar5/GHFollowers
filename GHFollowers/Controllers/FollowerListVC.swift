//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Burkay Atar on 31.12.2023.
//

import UIKit

class FollowerListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var username: String?
    var followers: [Follower] = []
    
    var collectionView: UICollectionView?
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: "FollowerCell")
    }
    
    
    
    private func getFollowers() {
        if let username = self.username {
            NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let followers):
                        self.followers = followers
                        self.updateData()
                    
                    case .failure(let error):
                        self.presentGHAlertOnMainThread(title: "Bad Stuff Happened",
                                                        message: error.rawValue,
                                                        buttonTitle: "Ok")
                }
            }
        }
    }
    
    private func configureDataSource() {
        guard let collectionView = collectionView else { return }
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCollectionViewCell.reuseID, for: indexPath) as! FollowerCollectionViewCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }

}
