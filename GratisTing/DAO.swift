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
    
    static let instance = DAO()
    
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
                
                // Get data
                let id = subJson["_id"].string!
                let title = subJson["title"].string!
                let image = subJson["image"].string!
                
                // Instantiate category
                let category = Category(id: id, title: title, imageURL: image)
                
                // Append to list of categories
                categories.append(category)
                
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
            
            var items: [Item] = []
            let jsonData = JSON(data: response.data!)
            
            // API responded with failure
            if jsonData["success"].bool! == false {
                let error = NSError(domain: jsonData["error"].string!, code: 0, userInfo: nil)
                completion(items: nil, error: error)
                return
            }
            
            var users: [String : User] = [:]
            var categories: [String : Category] = [:]
            
            for (_, itemJson) in jsonData["relationships"]["users"] {
                // User
                let userId = itemJson["_id"].string!
                let email = itemJson["email"].string!
                let name = itemJson["name"].string
                
                // Address
                let address = itemJson["address"]["address"].string
                let cityName = itemJson["address"]["cityName"].string
                let postalCode = itemJson["address"]["postalCode"].int
                let long = itemJson["address"]["location"]["coordinates"][0].double!
                let lat = itemJson["address"]["location"]["coordinates"][1].double!
                let completeAddress = Address(address: address!, cityName: cityName!, postalCode: postalCode!, latitude: lat, longitude: long)
                
                let user = User(id: userId, email: email, name: name!, address: completeAddress)
                
                users[userId] = user
                
            }
            
            for (_, itemJson) in jsonData["relationships"]["categories"] {
                // User
                let id = itemJson["_id"].string!
                let image = itemJson["image"].string!
                let title = itemJson["title"].string!
                
                let category = Category(id: id, title: title, imageURL: image)
                
                categories[id] = category
                
            }

            
            // Parse json
            for (_, subJson) in jsonData["data"] {
                
                // Get data
                let id = subJson["_id"].string!
                let title = subJson["title"].string!
                let description = subJson["description"].string!
                let userId = subJson["owner"].string!
                let catId = subJson["category"].string!
                let lat = subJson["address"]["location"]["coordinates"][1].double!
                let long = subJson["address"]["location"]["coordinates"][0].double!
                // TODO: calcuate distance
                
                // Instantiate item
                let item = Item(
                    id: id,
                    title: title,
                    description: description,
                    imageURL: "http://google.dk/logo.png",
                    createdAt: NSDate(),
                    owner: users[userId]!,
                    latitude: lat,
                    longitude: long,
                    category: categories[catId]!
                )
                
                
                // Append item to list of items
                items.append(item)
            }
            
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
            
            var items: [Item] = []
            let jsonData = JSON(data: response.data!)
            var users: [String : User] = [:]
            var categories: [String : Category] = [:]
            
            // API responded with failure
            if jsonData["success"].bool! == false {
                let error = NSError(domain: jsonData["error"].string!, code: 0, userInfo: nil)
                completion(items: nil, error: error)
                return
            }
            
            for (_, itemJson) in jsonData["relationships"]["users"] {
                // User
                let userId = itemJson["_id"].string!
                let email = itemJson["email"].string!
                let name = itemJson["name"].string
                
                // Address
                let address = itemJson["address"]["address"].string
                let cityName = itemJson["address"]["cityName"].string
                let postalCode = itemJson["address"]["postalCode"].int
                let long = itemJson["address"]["location"]["coordinates"][0].double!
                let lat = itemJson["address"]["location"]["coordinates"][1].double!
                let completeAddress = Address(address: address!, cityName: cityName!, postalCode: postalCode!, latitude: lat, longitude: long)
                
                let user = User(id: userId, email: email, name: name!, address: completeAddress)
                
                users[userId] = user

            }
            
            for (_, itemJson) in jsonData["relationships"]["categories"] {
                // User
                let id = itemJson["_id"].string!
                let image = itemJson["image"].string!
                let title = itemJson["title"].string!
                
                let category = Category(id: id, title: title, imageURL: image)
                
                categories[id] = category
                
            }
            
            for (_, itemJson) in jsonData["data"] {
                
                let itemId = itemJson["_id"].string!
                let categoryId = itemJson["category"].string!
                let ownerId = itemJson["owner"].string!
                let lat = itemJson["address"]["location"]["coordinates"][1].double!
                let long = itemJson["address"]["location"]["coordinates"][0].double!
                let itemTitle = itemJson["title"].string!
                let itemDescription = itemJson["description"].string!
                
                
                let item = Item(
                    id: itemId,
                    title: itemTitle,
                    description: itemDescription,
                    imageURL: "http://placehold.it/350x150",
                    createdAt: NSDate(),
                    owner: users[ownerId]!,
                    latitude: lat,
                    longitude: long,
                    category: categories[categoryId]!
                )
                
                items.append(item)
            }
            
            completion(items: items, error: nil)

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

            // User
            let userId = jsonData["data"]["_id"].string!
            let email = jsonData["data"]["email"].string!
            let name = jsonData["data"]["name"].string
            
            // Address
            let address = jsonData["data"]["address"]["address"].string
            let cityName = jsonData["data"]["address"]["cityName"].string
            let postalCode = jsonData["data"]["address"]["postalCode"].int
            let long = jsonData["data"]["address"]["location"]["coordinates"][0].double!
            let lat = jsonData["data"]["address"]["location"]["coordinates"][1].double!
            let completeAddress = Address(address: address!, cityName: cityName!, postalCode: postalCode!, latitude: lat, longitude: long)
            
            let user = User(id: userId, email: email, name: name!, address: completeAddress)
            
            completion(user: user, error: nil)

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
            let itemJson = jsonData["data"]
            let itemId = itemJson["_id"].string!
            let categoryId = itemJson["category"].string!
            let lat = itemJson["address"]["location"]["coordinates"][1].double!
            let long = itemJson["address"]["location"]["coordinates"][0].double!
            let itemTitle = itemJson["title"].string!
            let itemDescription = itemJson["description"].string!
            
            // Instantiate fake category. TODO: parse real category
            let category = Category(id: categoryId, title: "", imageURL: "")
            
            
            let item = Item(
                id: itemId,
                title: itemTitle,
                description: itemDescription,
                imageURL: "http://placehold.it/350x150",
                createdAt: NSDate(),
                owner: user,
                latitude: lat,
                longitude: long,
                category: category
            )
            
            completion(item: item, error: nil)
        }
    }
    
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
            let email = jsonData["data"]["email"].string!
            let name = jsonData["data"]["name"].string
            
            // Address
            let address = jsonData["data"]["address"]["address"].string
            let cityName = jsonData["data"]["address"]["cityName"].string
            let postalCode = jsonData["data"]["address"]["postalCode"].int
            let long = jsonData["data"]["address"]["location"]["coordinates"][0].double!
            let lat = jsonData["data"]["address"]["location"]["coordinates"][1].double!
            let completeAddress = Address(address: address!, cityName: cityName!, postalCode: postalCode!, latitude: lat, longitude: long)
            
            let user = User(id: userId, email: email, name: name!, address: completeAddress)
            
            completion(user: user, error: nil)
        }
        
    }
    
    
}

