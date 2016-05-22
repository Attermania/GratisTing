//
//  DAOProtocol.swift
//  GratisTing
//
//  Created by Thomas Attermann on 12/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation

protocol DAOProtocol {
    
    func getAllCategories(completion: (categories: [Category]?, error: NSError?) -> Void)
    
    func getItems(category: Category?, completion: (items: [Item]?, error: NSError?) -> Void)
    
    func getItemsFromLocation(categoryId: String?, latitude: Double, longitude: Double, radius: Int, completion: (items: [Item]?, error: NSError?) -> Void)
    
    func createUser(user: User, completion: (user: User?, error: NSError?) -> Void)
    
    func createItem(item: Item, token: String, user: User, completion: (item: Item?, error: NSError?) -> Void)
    
    func getUser(userId: String, completion: (user: User?, error: NSError?) -> ())
    
}