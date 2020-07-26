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
    var currentUser: User?
    var userToLoadFromSearchVC: User?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //header
        self.collectionView!.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        configureUI()
        
        if userToLoadFromSearchVC == nil {
            fetchCurrentUserData()
        }
    }
    
    //MARK: - Selectors
    
    
    //MARK: - API
    
    func fetchCurrentUserData() {
        guard let currentUser = Auth.auth().currentUser else { return }

        Service.shared.fetchUserData(forUID: currentUser.uid) { (user) in
            self.navigationItem.title = user.username
            self.currentUser = user
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
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        
        //set delegate
        header.delegate = self
        
        //set user in header
        if let currentUser = self.currentUser {
            header.user = currentUser
        }
        else if let userToLoadFromSearchVC = self.userToLoadFromSearchVC {
            header.user = userToLoadFromSearchVC
            navigationItem.title = userToLoadFromSearchVC.username
        }
        
        // return header
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

//MARK: - Delegate UICollectionViewDelegateFlowLayout
//setting height for the header
extension UserProfileController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: (view.frame.height - (view.frame.height * 0.755)))
    }
}

//MARK: - Delegate UserProfileDelegate
extension UserProfileController: UserProfileHeaderDelegate {
    
    func handleFollowersTapped(for header: UserProfileHeader) {
        print("DEBUG: Handle handleFollowersTapped")
    }
    
    func handleFollowingTapped(for header: UserProfileHeader) {
        print("DEBUG: Handle handleFollowingTapped")
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
        }
    }
    
    func setUserStats(for header: UserProfileHeader) {
        guard let user = header.user else { return }
        
        Service.shared.getUserStats(for: user.uid) { (stats) in
            guard let following = stats["noOfFollowing"] else { return }
            guard let followers = stats["noOfFollowers"] else { return }
            
            let attributedFollowingText = NSMutableAttributedString(string: "\(following)\n", attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedFollowingText.append(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
            header.followingLabel.attributedText = attributedFollowingText
            
            let attributedFollowerText = NSMutableAttributedString(string: "\(followers)\n", attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedFollowerText.append(NSAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
            header.followersLabel.attributedText = attributedFollowerText
        }
    }
}
