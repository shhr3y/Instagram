//
//  SelectPhotoHeader.swift
//  Instagram
//
//  Created by Shrey Gupta on 09/08/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit

class SelectPhotoHeader: UICollectionViewCell {
    //MARK: - Properties
    
    lazy var selectedImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .darkGray
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
    
    //MARK: - Helper Functions
    
    func configureUI(){
         addSubview(selectedImageView)
        selectedImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
}
