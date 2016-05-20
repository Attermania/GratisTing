//
//  DAOProtocol.swift
//  GratisTing
//
//  Created by Thomas Attermann on 12/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation

protocol DAOProtocol {
    
    func getAllCategories(completion: [Category] -> Void)
    
    func getItems(category: Category?, latitude: Double, longitide: Double) -> [Item]
    
    func getItemsFromLocation(categoryId: String?, latitude: Double, longitude: Double, radius: Int, completion: [Item] -> Void)
    
    func createUser(user: User)
    
    func createItem(item: Item, token: String)
    
    func getUser(userId: String, completion: (error: NSError?, user: User?) -> ())
    
}