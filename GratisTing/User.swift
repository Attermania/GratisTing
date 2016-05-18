//
//  User.swift
//  GratisTing
//
//  Created by Thomas Attermann on 11/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation

class User {
    
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phoneNumber: Int?
    var items:[Item] = []
    var address: Address?
    
    /*
     Constructor without id parameter. Used when creating User object in the app. Id will be assigned in DB.
     */
    init(firstName : String, lastName: String, email: String, phoneNumber: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
    /**
     Constructor with id attribute. Used when parsing JSON to User object.
     */
    init(id: String, firstName : String, lastName: String, email: String, phoneNumber: Int) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
    }
}
