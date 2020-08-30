//
//  Comment.swift
//  Instagram
//
//  Created by Shrey Gupta on 30/08/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import Foundation

class Comment {
    var postID: String
    var comment: String
    var creationDate: Date
    var user: User?
    
    init(postID: String, user: User, dictionary: [String: Any]) {
        self.user = user
        self.comment = dictionary["comment"] as? String ?? ""
        self.postID = postID
        let creationDateRaw = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: creationDateRaw)
    }
}
