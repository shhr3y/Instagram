//
//  SearchUserCell.swift
//  Instagram
//
//  Created by Shrey Gupta on 24/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {

    //MARK: - Properties
    private let userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(userProfileImageView)
        userProfileImageView.anchor(left: leftAnchor, paddingLeft: 8, width: 48, height: 48)
        userProfileImageView.centerY(inView: self)
        userProfileImageView.layer.cornerRadius = 48/2
        userProfileImageView.clipsToBounds = true
        
        self.textLabel?.text = "shhr3y"
        self.detailTextLabel?.text = "Shrey Gupta"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 68, y: self.textLabel!.frame.origin.y, width: self.textLabel!.frame.width, height: self.textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 68, y: self.textLabel!.frame.origin.y + 18, width: self.frame.width - 108, height: self.textLabel!.frame.height)
        
        textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel?.textColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
