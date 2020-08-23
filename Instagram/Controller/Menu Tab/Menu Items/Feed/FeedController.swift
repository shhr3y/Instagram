//
//  FeedController.swift
//  Instagram
//
//  Created by Shrey Gupta on 22/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

protocol FeedControllerDelegate: class {
    func authStateChanged()
}

class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    var delegate: FeedControllerDelegate?
    var viewSinglePost = false
    var post: Post?
    
    var posts = [Post]()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //changing background color
        collectionView.backgroundColor = .white
        
        // Register cell classes
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        //add refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        //customizing navigation bar
        configureNavigationBar()
        
        // setFeeds only if it not in singleViewPostMode
        if !viewSinglePost {
            setFeedPosts()
        }
    }
   
    //MARK: - Selectors
    
    @objc func handleLogout() {
        
        //declare alert controller
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .actionSheet)
        
        //add alert action
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
            do {
                try Auth.auth().signOut()
                guard let mainTabVC = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController else { return }
                mainTabVC.checkIfTheUserIsLoggedIn()
            }catch {
                print("DEBUG: handleLogout Error: \(error.localizedDescription)")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func handleDMTapped() {
        print("DEBUG: HandleDMTapped")
    }
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        
        viewDidLoad()
    }
    //MARK: - Helper Functions
    
    func configureNavigationBar() {
        if viewSinglePost {
            //configuration for SinglePost
            //changing navigation bar title
            self.navigationItem.title = "Post"
        }else{
            //configuration for Feed
            //changing navigation bar title
            self.navigationItem.title = "Feed"
            //adding logout button
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
            //adding messaging button
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send2"), style: .plain, target: self, action: #selector(handleDMTapped))
        }
    }
    
    
    //MARK: - API
    func setFeedPosts() {
        Service.shared.updateUserFeedForFollowingUser()
        fetchPosts()
        self.collectionView.reloadData()
    }
    
    
    func fetchPosts(){
        print("DEBUG:- FetchPost called")
        Service.shared.fetchFeedPosts { (post) in
            self.collectionView.reloadData()
            self.posts.append(post)
            
            self.posts.sort { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            }
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if viewSinglePost {
            return 1
        }
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        
        if viewSinglePost {
            if let post = self.post {            
                cell.post = post
            }
        }else{
            cell.post = self.posts[indexPath.row]
        }
        return cell
    }
}

//MARK: - Delegate UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = width + 8 + 40 + 8 + 50 + 60
        return CGSize(width: width, height: height)
    }
}

//MARK: - Delegate FeedCellDelegate

extension FeedController: FeedCellDelegate {
    func handleUsernameTapped(for cell: FeedCell) {
        guard let post = cell.post else { return }
        
        let controller = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.user = post.user
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleOptionsTapped(for cell: FeedCell) {
        print("DEBUG:- handleOptionsTapped for cell: \(cell)")
    }
    
    func handleLikeTapped(for cell: FeedCell) {
        guard let post = cell.post else { return }
        
        Service.shared.updateLikeStatus(for: post)
    }
    
    func handleCommentTapped(for cell: FeedCell) {
        print("DEBUG:- handleCommentTapped for cell: \(cell)")
    }
}
