//
//  UserPostCell.swift
//  Instagram
//
//  Created by Shrey Gupta on 16/08/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit

class UserPostCell: UICollectionViewCell {
    //MARK: - Properties
    var post: Post? {
        didSet{
            guard let imageUrl = post?.imageURL else { return }
            postImageView.loadImage(from: imageUrl)
        }
    }
    
    private let postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
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
    func configureUI() {
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
}
