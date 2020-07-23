//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Shrey Gupta on 23/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    
    //MARK: - Properties
    
    var user: User? {
        didSet{
            guard let name = user?.name else { return }
            nameLabel.text = name
            
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
    
    private let nameLabel: UILabel = {
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
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(string: "15\n", attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(string: "50\n", attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Edit Profile", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
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
    
    
    //MARK: - Helper Functions
    
    func configureUI(){
        addShadow()
        backgroundColor = .white
        
        addSubview(userProfileImageView)
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        userProfileImageView.setDimensions(height: 90, width: 90)
        userProfileImageView.layer.cornerRadius = 90/2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: userProfileImageView.bottomAnchor,left: leftAnchor, paddingTop: 8, paddingLeft: 18)
        
        let userStatusStack = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        userStatusStack.axis = .horizontal
        userStatusStack.distribution = .fillEqually
        userStatusStack.spacing = 5
        addSubview(userStatusStack)
        userStatusStack.anchor(left: userProfileImageView.rightAnchor, right: rightAnchor, paddingLeft: 10, paddingRight: 10, height: 50)
        userStatusStack.centerY(inView: userProfileImageView)
        
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
        
        addSubview(editProfileButton)
        editProfileButton.anchor(bottom: bottomStack.topAnchor, paddingTop: 20, paddingBottom: 8)
        editProfileButton.setDimensions(height: 30, width: frame.width - 40)
        editProfileButton.centerX(inView: self)
        
    }

}
