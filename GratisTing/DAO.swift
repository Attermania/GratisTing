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

        let chair = Item(title: "Ægget", description: "Slidt men flot", imageURL: "", createdAt: NSDate(), owner: jon, latitude: 55.71, longitude: 12.51)
        let sword = Item(title: "Hearteater", description: "Perfekt stand og meget flot sværd. Det er bare rigtig godt.", imageURL: "", createdAt: NSDate(), owner: jon, latitude: 55.7, longitude: 12.5)
        let pony = Item(title: "Pony", description: "Flot hest", imageURL: "", createdAt: NSDate(), owner: ben, latitude: 55.72, longitude: 12.52)
        items.append(chair)
        items.append(sword)
        items.append(pony)
    }
    
}
