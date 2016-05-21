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
            
            // Parse json
            for (_, subJson) in jsonData["data"] {
                
                // Get data
                let id = subJson["obj"]["_id"].string!
                let title = subJson["obj"]["title"].string!
                let description = subJson["obj"]["description"].string!
                let userId = subJson["obj"]["owner"].string!
                let catId = subJson["obj"]["category"].string!
                let lat = subJson["obj"]["address"]["coordinates"][1].double!
                let long = subJson["obj"]["address"]["coordinates"][0].double!
                let distance = subJson["dis"].double!
                
                // Instantiate fake user - TODO: parse real user
                let user = User(
                    id: userId,
                    email: "jsdad",
                    name: "ole",
                    address: Address(
                        address: "lygten 7",
                        cityName: "kbh",
                        postalCode: 2670,
                        latitude: 42,
                        longitude: 213.2
                    )
                )
                
                // Instantiate fake category . TODO: parse real category
                let cat = Category(id: catId, title: "", imageURL: "")
                
                // Instantiate item
                let item = Item(
                    id: id,
                    title: title,
                    description: description,
                    imageURL: "http://google.dk/logo.png",
                    createdAt: NSDate(),
                    owner: user,
                    latitude: lat,
                    longitude: long,
                    category: cat,
                    distance: distance
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
            
            // API responded with failure
            if jsonData["success"].bool! == false {
                let error = NSError(domain: jsonData["error"].string!, code: 0, userInfo: nil)
                completion(items: nil, error: error)
                return
            }
            
            for (_, itemJson) in jsonData["data"] {
                
                let itemId = itemJson["_id"].string!
                let ownerId = itemJson["owner"].string!
                let categoryId = itemJson["category"].string!
                let formattedAddress = itemJson["address"]["address"].string!
                let cityName = itemJson["address"]["cityName"].string!
                let postalCode = itemJson["address"]["postalCode"].int!
                let lat = itemJson["address"]["coordinates"][1].double!
                let long = itemJson["address"]["coordinates"][0].double!
                let itemTitle = itemJson["title"].string!
                let itemDescription = itemJson["description"].string!
                
                let user = User(
                    id: ownerId,
                    email: "jsdad",
                    name: "ole",
                    address: Address(
                        address: formattedAddress,
                        cityName: cityName,
                        postalCode: postalCode,
                        latitude: lat,
                        longitude: long
                    )
                )
                
                let category = Category(id: categoryId, title: "min hest", imageURL: "http://placehold.it/350x150")
                
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
                "coordinates": [
                    user.address.longitude,
                    user.address.latitude
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
            let long = jsonData["data"]["address"]["coordinates"][0].double!
            let lat = jsonData["data"]["address"]["coordinates"][1].double!
            let completeAddress = Address(address: address!, cityName: cityName!, postalCode: postalCode!, latitude: lat, longitude: long)
            
            let user = User(id: userId, email: email, name: name!, address: completeAddress)
            
            completion(user: user, error: nil)

        }
    }
    
    // MARK: Create item
    func createItem(item: Item, token: String, completion: (item: Item?, error: NSError?) -> Void) {
        
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
                "coordinates": [
                    item.address!.longitude,
                    item.address!.latitude
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
            let ownerId = itemJson["owner"].string!
            let categoryId = itemJson["category"].string!
            let formattedAddress = itemJson["address"]["address"].string!
            let cityName = itemJson["address"]["cityName"].string!
            let postalCode = itemJson["address"]["postalCode"].int!
            let lat = itemJson["address"]["coordinates"][1].double!
            let long = itemJson["address"]["coordinates"][0].double!
            let itemTitle = itemJson["title"].string!
            let itemDescription = itemJson["description"].string!
            
            // Instantiate fake category. TODO: parse real category
            let category = Category(id: categoryId, title: "", imageURL: "")
            
            // Instantiate fake user. TODO: parse real user
            let user = User(
                id: ownerId,
                email: "jsdad",
                name: "ole",
                address: Address(
                    address: formattedAddress,
                    cityName: cityName,
                    postalCode: postalCode,
                    latitude: lat,
                    longitude: long
                )
            )
            
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
            let long = jsonData["data"]["address"]["coordinates"][0].double!
            let lat = jsonData["data"]["address"]["coordinates"][1].double!
            let completeAddress = Address(address: address!, cityName: cityName!, postalCode: postalCode!, latitude: lat, longitude: long)
            
            let user = User(id: userId, email: email, name: name!, address: completeAddress)
            
            completion(user: user, error: nil)
        }
        
    }
    
    
}

