//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Burkay Atar on 31.12.2023.
//

import UIKit

class FollowerListVC: GHDataLoadingVC {
    
    enum Section {
        case main
    }
    
    var username: String?
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page: Int = 1
    var hasMoreFollowers: Bool = true
    var isSearching = false
    var isLoadingMoreFollowers: Bool = false
    
    var collectionView: UICollectionView?
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: "FollowerCell")
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        //searchController.obscuresBackgroundDuringPresentation = false -> to not obscure the collection view when typing.
        searchController.searchBar.placeholder = "Search for a username."
        navigationItem.searchController = searchController
        
    }
    
    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        
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
                    
                    if self.followers.isEmpty {
                        let message = "This user does not have any followers. Go follow them 😀."
                        DispatchQueue.main.async {
                            self.showEmptyStateView(with: message, in: self.view)
                        }
                        return
                    }
                    
                    self.updateData(on: self.followers)
                    
                case .failure(let error):
                    self.presentGHAlertOnMainThread(title: "Bad Stuff Happened",
                                                    message: error.rawValue,
                                                    buttonTitle: "Ok")
                }
                self.isLoadingMoreFollowers = false
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
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc private func addButtonTapped() {
        showLoadingView()
        guard let username = username else { return }
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
                case .success(let user):
                    let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                    
                    PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                        guard let self = self else { return }
                        guard let error = error else {
                            self.presentGHAlertOnMainThread(title: "Success",
                                                            message: "You have successfully favorited this user.",
                                                            buttonTitle: "Ok")
                            return
                        }
                        self.presentGHAlertOnMainThread(title: "Something went wrong",
                                                        message: error.rawValue,
                                                        buttonTitle: "Ok")
                    }
                case .failure(let error):
                    self.presentGHAlertOnMainThread(title: "Something went wrong",
                                                message: error.rawValue,
                                                buttonTitle: "Ok")
            }
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
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            if let username = username {
                getFollowers(username: username, page: page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destinationVC = UserInfoVC()
        destinationVC.username = follower.login
        destinationVC.delegate = self
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { 
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for username: String) {
        //Get followers for requested user.
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
