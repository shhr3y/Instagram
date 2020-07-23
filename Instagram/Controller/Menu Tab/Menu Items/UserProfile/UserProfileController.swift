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
    var user: User?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //header
        self.collectionView!.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        configureUI()
        fetchCurrentUserData()
    }
    
    //MARK: - Selectors
    
    
    //MARK: - API
    
    func fetchCurrentUserData() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        Database.database().reference().child("users").child(currentUser.uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let user = User(uid: uid, dictionary: userDictionary)

            self.navigationItem.title = user.username
            
            self.user = user
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
        
        if let user = self.user {
            header.user = user
        }
        
        // return header
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}


extension UserProfileController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: (view.frame.height - (view.frame.height * 0.755)))
    }
}
