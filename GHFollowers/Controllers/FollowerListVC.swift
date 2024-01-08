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
    var page: Int = 1
    var hasMoreFollowers: Bool = true
    
    var collectionView: UICollectionView?
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        
        if let username = username {
            getFollowers(username: username, page: page)
        }
        
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
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: "FollowerCell")
    }
    
    
    
    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        if let username = self.username {
            NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
                guard let self = self else { return }
                self.dismissLoadingView()
                switch result {
                    case .success(let followers):
                    /*
                     We get 100 followers per page now.
                     If the follower count is less then 100 this means there are no more followers on the next page.
                     So we do not make any unneccesary network call.
                     TODO: - In an edge case like user has 400 followers we will make 1 more unncessary call. Try to fix it.
                    */
                    if followers.count < 100 { self.hasMoreFollowers = false }
                        self.followers.append(contentsOf: followers)
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

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //Content size is total height of scrool view including all the data.
        //Height of the scrool view is the total height of the screen.
        //Offset of the Y coordinate is how far you scrool vertically.
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            if let username = username {
                getFollowers(username: username, page: page)
            }
        }
    }
}
