//
//  DAO.swift
//  GratisTing
//
//  Created by Thomas Attermann on 12/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous
import SwiftyJSON

class DAO: DAOProtocol {
    
    // MARK: Instance variables
    static let instance = DAO()
    let jsonParser = JSONParser()
    
    // MARK: Get all categories
    func getAllCategories(completion: (categories: [Category]?, error: NSError?) -> Void) {
        
        Alamofire.request(.GET, "http://gratisting.dev:3000/api/v1/categories").responseJSON { (response) in
            
            // Something went wrong, abort
            if response.result.isFailure {
                completion(categories: nil, error: response.result.error)
                return
            }
            
            var categories: [Category] = []
            let jsonData = JSON(data: response.data!)
            
            // API responded with failure
            if jsonData["success"].bool! == false {
                let error = NSError(domain: jsonData["error"].string!, code: 0, userInfo: nil)
                completion(categories: nil, error: error)
                return
            }
            
            // Parse json
            for (_, subJson) in jsonData["data"] {
                
                // Parse category
                let category = self.jsonParser.parseCategory(subJson);
                
                // Append to list of categories
                if category != nil {
                    categories.append(category!);
                }
            }
            
            // Call completion handler
            completion(categories: categories, error: nil)
            
        }
        
    }
    
    // MARK: Get items from a location
    func getItemsFromLocation(categoryId: String?, latitude: Double, longitude: Double, radius: Int, completion: (items: [Item]?, error: NSError?) -> Void) {
        
        // Prepare url query string parameters
        var parameters: [String : AnyObject] = [
            "lat": latitude,
            "long": longitude,
            "radius": radius
        ]
        
        // If a specfic category is requested add it to the query string parameters
        if categoryId != nil {
            parameters["categoryId"] = categoryId
        }
        
        Alamofire.request(.GET, "http://gratisting.dev:3000/api/v1/items", parameters: parameters, encoding: .URL).responseJSON { (response) in
            
            // Something went wrong, abort
            if response.result.isFailure {
                completion(items: nil, error: response.result.error)
                return
            }
            
            let jsonData = JSON(data: response.data!)
            
            // API responded with failure
            if jsonData["success"].bool! == false {
                let error = NSError(domain: jsonData["error"].string!, code: 0, userInfo: nil)
                completion(items: nil, error: error)
                return
            }
            
            // Parse items
            let items = self.jsonParser.parseItems(jsonData)
            
            // Call the completion handler
            completion(items: items, error: nil)
            
        }
    }
    
    // MARK: Get items ordered by creation time
    func getItems(category: Category?, completion: (items: [Item]?, error: NSError?) -> Void) {
        
        var parameters: [String : AnyObject] = [:]
        
        if category != nil {
            parameters["categoryId"] = category?.id
        }
        
        Alamofire.request(.GET, "http://gratisting.dev:3000/api/v1/items", parameters: parameters, encoding: .URL).responseJSON { (response) in
            
            // Something went wrong, abort
            if response.result.isFailure {
                completion(items: nil, error: response.result.error)
                return
            }
            
            let jsonData = JSON(data: response.data!)
            
            // API responded with failure
            if jsonData["success"].bool! == false {
                let error = NSError(domain: jsonData["error"].string!, code: 0, userInfo: nil)
                completion(items: nil, error: error)
                return
            }
            
            let items = self.jsonParser.parseItems(jsonData)
            
            completion(items: items, error: nil)
            
        }
        
    }
    
    // MARK: Create item
    func createItem(item: Item, token: String, user: User, completion: (item: Item?, error: NSError?) -> Void) {
        
        let headers = [
            "Authorization": token,
            "Content-Type": "application/json"
        ]
        
        let parameters = [
            "title": item.title,
            "description": item.description,
            "imageURL": item.imageURL,
            "owner": (item.owner?.id)!,
            "address": [
                "address": item.address!.address,
                "cityName": item.address!.cityName,
                "postalCode": item.address!.postalCode,
                "location": [
                    "coordinates": [
                        item.address!.longitude,
                        item.address!.latitude
                    ]
                ]
            ],
            "categoryId": (item.category!.id)!
        ]
        
        Alamofire.request(.POST, "http://gratisting.dev:3000/api/v1/items", parameters: (parameters as! [String : AnyObject]), encoding: .JSON, headers: headers).responseJSON { (response) in
            // Something went wrong, abort
            if response.result.isFailure {
                completion(item: nil, error: response.result.error)
                return
            }
            
            let jsonData = JSON(data: response.data!)
            
            // API responded with failure
            if jsonData["success"].bool! == false {
                let error = NSError(domain: jsonData["error"].string!, code: 0, userInfo: nil)
                completion(item: nil, error: error)
                return
            }
            
            // Parse category
            let category = self.jsonParser.parseCategory(jsonData["relationships"]["category"])
            
            // Parse item
            let item     = self.jsonParser.parseItem(jsonData["data"], owner: user, category: category!)
            
            completion(item: item, error: nil)
        }
    }
    
    // MARK: Create user
    func createUser(user: User, completion: (user: User?, error: NSError?) -> Void) {
        
        let parameters = [
            "email": user.email,
            "password": user.password,
            "name": user.name,
            "address": [
                "address": user.address.address,
                "cityName": user.address.cityName,
                "postalCode": user.address.postalCode,
                "location": [
                    "coordinates": [
                        user.address.longitude,
                        user.address.latitude
                    ]
                ]
            ]
        ]
        
        Alamofire.request(.POST, "http://gratisting.dev:3000/api/v1/users", parameters: (parameters as! [String : AnyObject]), encoding: .JSON).responseJSON { (response) in
            // Something went wrong, abort
            if response.result.isFailure {
                completion(user: nil, error: response.result.error)
                return
            }
            
            let jsonData = JSON(data: response.data!)
            
            // API responded with failure
            if jsonData["success"].bool! == false {
                let error = NSError(domain: jsonData["error"].string!, code: 0, userInfo: nil)
                completion(user: nil, error: error)
                return
            }
            
            // Parse user
            let user = self.jsonParser.parseUser(jsonData["data"])
            
            completion(user: user, error: nil)
            
        }
    }
    
    // MARK: Get a user by id
    func getUser(userId: String, completion: (user: User?, error: NSError?) -> ()) {
        
        Alamofire.request(.GET, "http://gratisting.dev:3000/api/v1/users/" + userId).responseJSON { (response) in
            
            // Something went wrong, abort
            if response.result.isFailure {
                completion(user: nil, error: response.result.error)
                return
            }
            
            let jsonData = JSON(data: response.data!)
            
            // API responded with failure
            if jsonData["success"].bool! == false {
                let error = NSError(domain: jsonData["error"].string!, code: 0, userInfo: nil)
                completion(user: nil, error: error)
                return
            }
            
            // User
            let user = self.jsonParser.parseUser(jsonData["data"])
            
            completion(user: user, error: nil)
        }
        
    }
    
    // MARK: Authenticate
    func authenticate(email: String, password: String, completion: (token: String?, user: User?, error: NSError?) -> ()) {
        
        let parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(.POST, "http://gratisting.dev:3000/api/v1/authenticate", parameters: parameters, encoding: .JSON).responseJSON { (response) in
            
            // Something went wrong, abort
            if response.result.isFailure {
                completion(token: nil, user: nil, error: response.result.error)
                return
            }
            
            var jsonData = JSON(data: response.data!)
            
            // API responded with failure
            if jsonData["success"].bool! == false {
                let error = NSError(domain: jsonData["error"].string!, code: 0, userInfo: nil)
                completion(token: nil, user: nil, error: error)
                return
            }
            
            let user            = self.jsonParser.parseUser(jsonData["data"]["user"])
            let authHeaderToken = jsonData["data"]["token"].string
            let jwtStringIndex  = authHeaderToken?.startIndex.advancedBy(4)
            
            if authHeaderToken == nil || user == nil || jwtStringIndex == nil {
                completion(token: nil, user: nil, error: NSError(domain: "Invalid auth header or no user", code: 0, userInfo: nil))
            }
            
            let index = jwtStringIndex!
            let token = authHeaderToken?.substringFromIndex(index)
            
            completion(token: token, user: user!, error: nil)
        }
    }
    
}