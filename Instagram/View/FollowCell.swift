//
//  FollowCell.swift
//  Instagram
//
//  Created by Shrey Gupta on 27/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit
import Firebase

protocol FollowCellDelegate: class {
    func handleFollowTapped(for cell: FollowCell)
}

class FollowCell: UITableViewCell {

    //MARK: - Properties
    var delegate: FollowCellDelegate?
    
    var user: User? {
        didSet{
            guard let user = user else { return }
            
            textLabel?.text = user.username
            detailTextLabel?.text = user.name
            userProfileImageView.loadImage(from: user.profileImageURL)
            
            //hide follow button for current user
            guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
            if user.uid == currentUserUid {
                self.followButton.isHidden = true
            }
            
            user.checkIfUserIsFollowed { (followStats) in
                if followStats {
                    self.followButton.setTitle("Following", for: .normal)
                    self.followButton.setTitleColor(.black, for: .normal)
                    self.followButton.backgroundColor = .white
                    self.followButton.layer.borderColor = UIColor.darkGray.cgColor
                    self.followButton.layer.borderWidth = 1
                }else{
                    self.followButton.setTitle("Follow", for: .normal)
                    self.followButton.setTitleColor(.white, for: .normal)
                    self.followButton.backgroundColor = .systemBlue
                    self.followButton.layer.borderWidth = 0
                }
            }
        }
    }
    
    lazy var userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Loading", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1

        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleFollowTapped() {
        delegate?.handleFollowTapped(for: self)
    }
    
    //MARK: - Helper Functions
    
    func configureUI() {
        self.selectionStyle = .none
        
        addSubview(userProfileImageView)
        userProfileImageView.anchor(left: leftAnchor, paddingLeft: 8, width: 48, height: 48)
        userProfileImageView.centerY(inView: self)
        userProfileImageView.layer.cornerRadius = 48/2
        userProfileImageView.clipsToBounds = true
        
        addSubview(followButton)
        followButton.anchor(right: rightAnchor, paddingRight: 10)
        followButton.centerY(inView: self)
        followButton.setDimensions(height: 30, width: 90)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 68, y: self.textLabel!.frame.origin.y, width: self.textLabel!.frame.width, height: self.textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 68, y: self.textLabel!.frame.origin.y + 18, width: self.frame.width - 108, height: self.textLabel!.frame.height)
        
        textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel?.textColor = .lightGray
    }
}
