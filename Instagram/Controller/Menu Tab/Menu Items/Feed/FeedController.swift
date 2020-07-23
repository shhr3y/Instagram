//
//  FeedController.swift
//  Instagram
//
//  Created by Shrey Gupta on 22/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

protocol FeedControllerDelegate: class {
    func authStateChanged()
}

class FeedController: UICollectionViewController {

    
    //MARK: - Properties
    var delegate: FeedControllerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLogOutButton()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    //MARK: - Helper Functions
    
    func configureLogOutButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout() {
        
        //declare alert controller
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .actionSheet)
        
        //add alert action
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
            do {
                try Auth.auth().signOut()
                guard let mainTabVC = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController else { return }
                mainTabVC.checkIfTheUserIsLoggedIn()
            }catch {
                print("DEBUG: handleLogout Error: \(error.localizedDescription)")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
