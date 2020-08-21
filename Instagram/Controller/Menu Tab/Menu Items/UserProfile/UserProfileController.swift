//
//  UserProfileController.swift
//  Instagram
//
//  Created by Shrey Gupta on 22/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"


class UserProfileController: UICollectionViewController {

    //MARK: - Properties
    var user: User?
    var posts = [Post]()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UserPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //register header
        self.collectionView!.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        //configure controller elements
        configureUI()
        
        //logic for current user profile or any other random user profile
        if user == nil {
            fetchCurrentUserData()
        }else{
            //fetch user profile
            fetchAllUsersPosts()
        }
    }
    
    //MARK: - Selectors
    
    
    //MARK: - API
    
    func fetchCurrentUserData() {
        guard let currentUser = Auth.auth().currentUser else { return }

        Service.shared.fetchUserData(forUID: currentUser.uid) { (user) in
            self.navigationItem.title = user.username
            self.user = user
            
            self.fetchAllUsersPosts()
        }
    }
    
    func fetchAllUsersPosts() {
        guard let user = self.user else { return }
        Service.shared.fetchAllPosts(for: user) { (post) in
            self.posts.append(post)
            
            self.posts.sort { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            }
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Helper Functions
    
    func configureUI() {
        self.collectionView.backgroundColor = .white
    }
    
    
    // MARK: - DataSource UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        
        //set delegate
        header.delegate = self
        
        //set user in header
        header.user = self.user
        navigationItem.title = self.user?.username
        
        // return header
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCell
        cell.post = posts[indexPath.row]
        return cell
    }
}

//MARK: - Delegate UICollectionViewDelegateFlowLayout
//setting height for the header
extension UserProfileController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: (view.frame.height - (view.frame.height * 0.755)))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

//MARK: - Delegate UserProfileDelegate

extension UserProfileController: UserProfileHeaderDelegate {
    
    func handleFollowersTapped(for header: UserProfileHeader) {
        guard let user = header.user else { return }
        
        let followVC = FollowController(type: .follower, user: user)
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    func handleFollowingTapped(for header: UserProfileHeader) {
        guard let user = header.user else { return }
        
        let followVC = FollowController(type: .following, user: user)
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    func handleEditFollowTapped(for header: UserProfileHeader) {
        print("DEBUG: handleEditFollowTapped is called")
        guard let user = header.user else { return }
        
        if header.editProfileFollowButton.titleLabel?.text == "Edit Profile" {
            //handle show edit profile controller
            print("DEBUG: Edit Profile Tapped")

        }else{
            //handle user follow/unfollow
            if header.editProfileFollowButton.titleLabel?.text == "Follow" {
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                user.follow()
            }else{
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                user.unfollow()
            }
            header.setUserStats(for: user)
        }
    }
    
    func setUserStats(for header: UserProfileHeader) {
        guard let user = header.user else { return }
        
        Service.shared.getUserStats(for: user.uid) { (stats) in
            guard let following = stats["noOfFollowing"] else { return }
            guard let followers = stats["noOfFollowers"] else { return }
            guard let noOfPosts = stats["noOfPosts"] else { return }
            
            
            let attributedPostsText = NSMutableAttributedString(string: "\(noOfPosts)\n", attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedPostsText.append(NSAttributedString(string: "Posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
            header.postsLabel.attributedText = attributedPostsText
            
            let attributedFollowingText = NSMutableAttributedString(string: "\(following)\n", attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedFollowingText.append(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
            header.followingLabel.attributedText = attributedFollowingText
            
            let attributedFollowerText = NSMutableAttributedString(string: "\(followers)\n", attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedFollowerText.append(NSAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
            header.followersLabel.attributedText = attributedFollowerText
        }
    }
}

