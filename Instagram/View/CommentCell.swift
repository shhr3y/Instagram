//
//  CommentCell.swift
//  Instagram
//
//  Created by Shrey Gupta on 30/08/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    //MARK: - Properties
    
    private let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let usernameLabel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("username", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "this is test comment: "
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.text = "5h"
        return label
    }()
    
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    
    func configureCell() {
        addSubview(userProfileImageView)
        userProfileImageView.anchor(left: leftAnchor, paddingLeft: 8, width: 48, height: 48)
        userProfileImageView.centerY(inView: self)
        userProfileImageView.layer.cornerRadius = 48/2
        userProfileImageView.clipsToBounds = true
        
        let HStack = UIStackView(arrangedSubviews: [usernameLabel, commentLabel])
        HStack.axis = .horizontal
        HStack.spacing = 5
        
        let VStack = UIStackView(arrangedSubviews: [HStack, dateLabel])
        VStack.axis = .vertical
        
        addSubview(VStack)
        VStack.anchor(left: userProfileImageView.rightAnchor, paddingLeft: 6)
        VStack.centerY(inView: userProfileImageView)
    }
}
