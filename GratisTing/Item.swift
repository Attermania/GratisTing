//
//  Item.swift
//  GratisTing
//
//  Created by Thomas Attermann on 11/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation

class Item {
    
    var title: String = ""
    var description: String = ""
    var imageURL: String = ""
    var createdAt: NSDate = NSDate()
    var owner: User?
    
    init (title: String, description: String, imageURL: String, createdAt: NSDate, owner: User) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.createdAt = createdAt
        self.owner = owner
    }
    
    
}
