//
//  DAO.swift
//  GratisTing
//
//  Created by Thomas Attermann on 12/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation

class DAO: DAOProtocol {
    
    var items:[Item] = []
    
    func getAllItems() -> [Item] {
        return items
    }
    
    // Function for initializing dummy data
    func initDummyData() {
        let jon = User(firstName: "Jon", lastName: "Snow", email: "Jon@snow.dk", phoneNumber: 12345)
        let ben = User(firstName: "Ben", lastName: "Affleck", email: "ben@snow.dk", phoneNumber: 34567)

        let chair = Item(title: "Ægget", description: "Slidt men flot", imageURL: "", createdAt: NSDate(), owner: jon)
        let sword = Item(title: "Hearteater", description: "Perfekt stand og meget flot sværd. Det er bare rigtig godt.", imageURL: "", createdAt: NSDate(), owner: jon)
        let pony = Item(title: "Pony", description: "Flot hest", imageURL: "", createdAt: NSDate(), owner: ben)
        items.append(chair)
        items.append(sword)
        items.append(pony)
    }
    
}
