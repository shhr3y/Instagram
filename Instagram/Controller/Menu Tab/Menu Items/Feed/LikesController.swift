//
//  LikesController.swift
//  Instagram
//
//  Created by Shrey Gupta on 23/08/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit


private let resuseIdentifier = "FollowCell"


class LikesController: UITableViewController {
    
    //MARK: - Properties
    let post: Post
    var allUsers = [User]()
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FollowCell.self, forCellReuseIdentifier: resuseIdentifier)
    }
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helper Functions
    func configure() {
        self.tableView.separatorStyle = .none
        navigationItem.title = "Likes"

        Service.shared.fetchLikedUsers(for: self.post) { (users) in
            for user in users {
                Service.shared.fetchUserData(forUID: user.key) { (user) in
                    self.allUsers.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Delegate Functions TableViewController
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resuseIdentifier, for: indexPath) as! FollowCell
        cell.user = allUsers[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = allUsers[indexPath.row]
        let userProfileVC = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = selectedUser

        navigationController?.pushViewController(userProfileVC, animated: true)
    }
}


//MARK: - Delegate FollowCell

extension LikesController: FollowCellDelegate {
    func handleFollowTapped(for cell: FollowCell) {
        guard let cellUser = cell.user else { return }
        if cellUser.isFollowed {
            cellUser.unfollow()
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.setTitleColor(.white, for: .normal)
            cell.followButton.backgroundColor = .systemBlue
            cell.followButton.layer.borderWidth = 0
        }else{
            cellUser.follow()
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.setTitleColor(.black, for: .normal)
            cell.followButton.backgroundColor = .white
            cell.followButton.layer.borderColor = UIColor.darkGray.cgColor
            cell.followButton.layer.borderWidth = 1
        }
    }
}
