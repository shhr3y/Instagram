//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Shrey Gupta on 23/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate: class {
    func handleFollowersTapped(for header: UserProfileHeader)
    func handleFollowingTapped(for header: UserProfileHeader)
    func handleEditFollowTapped(for header: UserProfileHeader)
    func setUserStats(for header: UserProfileHeader)
}

class UserProfileHeader: UICollectionViewCell {
    
    //MARK: - Properties
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet{
            configureProfileFollowButton()
            guard let name = user?.name else { return }
            fullnameLabel.text = name
            
            guard let profileImageURL = user?.profileImageURL else { return }
            userProfileImageView.loadImage(from: profileImageURL)
        }
    }
    
    private let userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let postsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "Posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(string: "15\n", attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(string: "50\n", attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Loading", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1

        button.addTarget(self, action: #selector(handleEditFollowTapped), for: .touchUpInside)
        return button
    }()
    
    private let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    private let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleFollowersTapped() {
        delegate?.handleFollowersTapped(for: self)
    }
    
    @objc func handleFollowingTapped() {
        delegate?.handleFollowingTapped(for: self)
    }
    
    @objc func handleEditFollowTapped() {
        delegate?.handleEditFollowTapped(for: self)
    }
    
    func setUserStats(for user: User){
        delegate?.setUserStats(for: self)
    }
    //MARK: - Helper Functions
    
    func configureUI(){
        addShadow()
        backgroundColor = .white
        
        addSubview(userProfileImageView)
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        userProfileImageView.setDimensions(height: 90, width: 90)
        userProfileImageView.layer.cornerRadius = 90/2
        
        addSubview(fullnameLabel)
        fullnameLabel.anchor(top: userProfileImageView.bottomAnchor,left: leftAnchor, paddingTop: 8, paddingLeft: 18)
        
        configureUserStats()
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        
        let bottomStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        
        addSubview(topDividerView)
        addSubview(bottomStack)
        addSubview(bottomDividerView)
        
        bottomStack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 43)
        topDividerView.anchor(top: bottomStack.topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        bottomDividerView.anchor(top: bottomStack.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(bottom: bottomStack.topAnchor, paddingTop: 20, paddingBottom: 8)
        editProfileFollowButton.setDimensions(height: 30, width: frame.width - 40)
        editProfileFollowButton.centerX(inView: self)
        
    }
    
    func configureUserStats() {
        let userStatusStack = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        userStatusStack.axis = .horizontal
        userStatusStack.distribution = .fillEqually
        userStatusStack.spacing = 5
        addSubview(userStatusStack)
        userStatusStack.anchor(left: userProfileImageView.rightAnchor, right: rightAnchor, paddingLeft: 10, paddingRight: 10, height: 50)
        userStatusStack.centerY(inView: userProfileImageView)
    }
    
    func configureProfileFollowButton() {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let user = self.user else { return }
        
        if currentUser.uid == user.uid {
            // config button as edit profile
            editProfileFollowButton.setTitle("Edit Profile", for: .normal)
        }else{
            // config button as follow or unfollow
            user.checkIfUserIsFollowed { (followStatus) in
                if followStatus {
                    self.editProfileFollowButton.setTitle("Following", for: .normal)
                    self.editProfileFollowButton.setTitleColor(.white, for: .normal)
                    self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
                }else{
                    self.editProfileFollowButton.setTitle("Follow", for: .normal)
                    self.editProfileFollowButton.setTitleColor(.white, for: .normal)
                    self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
                }
            }
        }
    }

}
