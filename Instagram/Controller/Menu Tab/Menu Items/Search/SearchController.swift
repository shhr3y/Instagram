//
//  SearchController.swift
//  Instagram
//
//  Created by Shrey Gupta on 22/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit

private let searchUserResuseIdentifier = "SearchUserCell"

class SearchController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //registering cell
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: searchUserResuseIdentifier)
        //set footer null
        tableView.tableFooterView = UIView()
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        //configuiring UI
        configureUI()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchUserResuseIdentifier, for: indexPath) as! SearchUserCell
        
        return cell
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        configureNavgationController()
    }
    
    func configureNavgationController(){
        navigationItem.title = "Explore"
    }
}
