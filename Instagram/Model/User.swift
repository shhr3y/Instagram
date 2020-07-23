//
//  File.swift
//  Instagram
//
//  Created by Shrey Gupta on 23/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
struct User {
    let uid: String
    let name: String
    let profileImageURL: String
    let username: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
}
