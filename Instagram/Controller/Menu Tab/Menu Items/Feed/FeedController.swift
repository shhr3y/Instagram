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
    
    var posts = [Post]()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //changing background color
        collectionView.backgroundColor = .white
        
        // Register cell classes
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        //customizing navigation bar
        configureNavigationBar()
        
        fetchPosts()
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
    //MARK: - Helper Functions
    
    func configureNavigationBar() {
        //adding logout button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        //changing navigation bar title
        self.navigationItem.title = "Feed"
        
        //adding messaging button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send2"), style: .plain, target: self, action: #selector(handleDMTapped))
    }
    
    
    //MARK: - API
    
    func fetchPosts(){
        Service.shared.fetchFeedPosts { (post) in
            self.posts.append(post)
            
            self.posts.sort { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            } 
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.post = self.posts[indexPath.row]
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

