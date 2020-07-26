//
//  SearchController.swift
//  Instagram
//
//  Created by Shrey Gupta on 22/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit
import Firebase

private let searchUserResuseIdentifier = "SearchUserCell"

class SearchController: UITableViewController {
    
    //MARK: - Properties
    private var allUsers = [User]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //registering cell
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: searchUserResuseIdentifier)
        //removing gray sepearators
        tableView.separatorStyle = .none
        //set footer null
        tableView.tableFooterView = UIView()
        //configuiring UI
        configureUI()
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        configureNavgationController()
        fetchAllUser()
    }
    
    func configureNavgationController(){
        navigationItem.title = "Explore"
    }
    
    //MARK: - API
    
    func fetchAllUser(){
        Service.shared.fetchAllUsers { (user) in
            self.allUsers.append(user)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - DataSource TableViewDataSource
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: searchUserResuseIdentifier, for: indexPath) as! SearchUserCell
        cell.user = allUsers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = allUsers[indexPath.row]
        
        //create instance of user profile controller
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.user = user
        //push viewcontriller
        navigationController?.pushViewController(userProfileController, animated: true)
    }
}
