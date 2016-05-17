//
//  Category.swift
//  GratisTing
//
//  Created by Thomas Attermann on 11/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation

class Category {
    
    var id: String?
    var title: String = ""
    var imageURL: String = ""
    
    init(id: String, title: String) {
        self.id    = id
        self.title = title
    }
    
    init(title: String) {
        self.title = title
    }
}