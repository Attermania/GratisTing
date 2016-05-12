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
    var categories: [Category] = []
    
    func getAllItems() -> [Item] {
        return items
    }
    
    func getAllCategories() -> [Category] {
        return categories
    }
    
    // Function for initializing dummy data
    func initDummyData() {
        
        //Categories
        let animals = Category(title: "Animals")
        let weapons = Category(title: "Weapons")
        let furniture = Category(title: "Møbler")
        
        // Users
        let jon = User(firstName: "Jon", lastName: "Snow", email: "Jon@snow.dk", phoneNumber: 12345)
        let ben = User(firstName: "Ben", lastName: "Affleck", email: "ben@snow.dk", phoneNumber: 34567)

        // Item
        let chair = Item(title: "Ægget", description: "Slidt men flot", imageURL: "", createdAt: NSDate(), owner: jon, latitude: 55.71, longitude: 12.51, category: furniture)
        let sword = Item(title: "Hearteater", description: "Perfekt stand og meget flot sværd. Det er bare rigtig godt.", imageURL: "", createdAt: NSDate(), owner: jon, latitude: 55.7, longitude: 12.5, category: weapons)
        let pony = Item(title: "Pony", description: "Flot hest", imageURL: "", createdAt: NSDate(), owner: ben, latitude: 55.72, longitude: 12.52, category: animals)
        
        categories.append(animals)
        categories.append(weapons)
        categories.append(furniture)
        
        items.append(chair)
        items.append(sword)
        items.append(pony)
        
    }
    
}
