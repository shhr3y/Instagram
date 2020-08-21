 //
//  FeedCell.swift
//  Instagram
//
//  Created by Shrey Gupta on 16/08/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit
 
 protocol FeedCellDelegate: class {
    func handleUsernameTapped(for cell: FeedCell)
    func handleOptionsTapped(for cell: FeedCell)
    func handleLikeTapped(for cell: FeedCell)
    func handleCommentTapped(for cell: FeedCell)
 }

class FeedCell: UICollectionViewCell {
    //MARK: - Properties
    var delegate: FeedCellDelegate?
    
    var post: Post? {
        didSet{
            guard let post = post else { return }
            
            Service.shared.fetchUserData(forUID: post.ownerUID) { (user) in
                self.usernameButton.setTitle(user.username, for: .normal)
                self.profileImageView.loadImage(from: user.profileImageURL)
                self.configurePostForCaptionAndLikes(forPost: post, user: user)
                self.postImageView.loadImage(from: post.imageURL)
                
                
            }
        }
    }
    
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray

        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleUsernameTapped))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("username", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "menu_options"), for: .normal)
        button.tintColor = .black
        button.setDimensions(height: 5, width: 18)
        
        button.addTarget(self, action: #selector(handleOptionTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let savePostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "3 likes"
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        let attributedText = NSMutableAttributedString(string: "username", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: " "))
        attributedText.append(NSMutableAttributedString(string: "this text is caption for the post above.", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        return label
    }()
    
    private lazy var postTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "2 DAYS AGO"
        return label
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
    @objc func handleUsernameTapped() {
        print("DEBUG:- username")
        delegate?.handleUsernameTapped(for: self)
    }
    
    @objc func handleOptionTapped() {
        print("DEBUG:- option")
        delegate?.handleOptionsTapped(for: self)
    }
    
    @objc func handleLikeTapped() {
        print("DEBUG:- like")
        delegate?.handleLikeTapped(for: self)
    }
    
    @objc func handleCommentTapped() {
        print("DEBUG:- comment")
        delegate?.handleCommentTapped(for: self)
    }
    
    //MARK: - Helper Functions
    
    func configureUI() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40/2
        
        addSubview(usernameButton)
        usernameButton.anchor(left: profileImageView.rightAnchor, paddingLeft: 8)
        usernameButton.centerY(inView: profileImageView)
        
        addSubview(optionButton)
        optionButton.anchor(right: rightAnchor, paddingRight: 15)
        optionButton.centerY(inView: profileImageView)
        
        let side = frame.width
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, paddingTop: 8)
        postImageView.setDimensions(height: side, width: side)
        postImageView.centerX(inView: self)
        
        configureActionButtons()
    }
    
    func configureActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, forwardButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, left: leftAnchor)
        stackView.setDimensions(height: 50, width: 120)
        
        addSubview(savePostButton)
        savePostButton.anchor(right: rightAnchor, paddingRight: 12)
        savePostButton.setDimensions(height: 22, width: 15)
        savePostButton.centerY(inView: stackView)
        
        addSubview(likeLabel)
        likeLabel.anchor(top: stackView.bottomAnchor, left: leftAnchor,paddingTop: -7, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeLabel.bottomAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 8)
    }
    
    func configurePostForCaptionAndLikes(forPost post: Post, user: User) {
        let attributedText = NSMutableAttributedString(string: "\(user.username)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: " "))
        attributedText.append(NSMutableAttributedString(string: "\(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        
        let date = post.creationDate
        let dateText = timeAgoSince(date)
        self.postTimeLabel.text = dateText.uppercased()
        
        captionLabel.attributedText = attributedText
        
        likeLabel.text = "\(post.likes) likes"
    }
}
