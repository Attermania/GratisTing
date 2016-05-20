//
//  DAOProtocol.swift
//  GratisTing
//
//  Created by Thomas Attermann on 12/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation

protocol DAOProtocol {
    
    func getAllCategories() -> [Category]
    
    func getItemsByCategory(category: Category?, latitude: Double, longitude: Double) -> [Item]
    
    func createUser(user: User)
    
    func createItem(item: Item, token: String)
    
    func getUser(userId: String, completion: (error: NSError?, user: User?) -> ())
    
}