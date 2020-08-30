//
//  CommentController.swift
//  Instagram
//
//  Created by Shrey Gupta on 23/08/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit

private let resuseIdentitfier = "CommentCellIdentifier"

class CommentController: UICollectionViewController {
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell Class
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: resuseIdentitfier)
        
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG:- APPEAR CALLED")
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    
    func configureUI() {
        self.navigationItem.title = "Comments"
        self.collectionView.backgroundColor = .white
    }
    
    //MARK: - UICollectionView
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
     
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentitfier, for: indexPath) as! CommentCell
        
        return cell
    }

}

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}
