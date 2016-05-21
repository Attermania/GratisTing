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
    
    func getAllCategories(completion: [Category] -> Void) {
        
        Alamofire.request(.GET, "http://gratisting.dev:3000/api/v1/categories").responseJSON { (response) in
            
            var categories: [Category] = []
            
            switch response.result {
                
            case .Success:
                print("success")
                let jsonData = JSON(data: response.data!)
                if jsonData.isEmpty {
                    print("empty response")
                }
                for (_, subJson) in jsonData["data"] {
                    print(subJson)
                    let id = subJson["_id"].string!
                    let title = subJson["title"].string!
                    let image = subJson["image"].string!
                    
                    let category = Category(id: id, title: title, imageURL: image)
                    
                    categories.append(category)
                }
                
                completion(categories)
                
            case .Failure(let error):
                print(error)
            }

        }
        
    }
    
    func getItemsFromLocation(categoryId: String?, latitude: Double, longitude: Double, radius: Int, completion: [Item] -> Void) {
        
        var parameters: [String : AnyObject] = [
            "lat": latitude,
            "long": longitude,
            "radius": radius
        ]
        
        if categoryId != nil {
            parameters["categoryId"] = categoryId
        }
        
        Alamofire.request(.GET, "http://gratisting.dev:3000/api/v1/items", parameters: parameters, encoding: .URL).responseJSON { (response) in
            
            var items: [Item] = []
            
            switch response.result {
                
            case .Success:
                let jsonData = JSON(data: response.data!)

                for (_, subJson) in jsonData["data"] {
                    
                    let id = subJson["obj"]["_id"].string!
                    let title = subJson["obj"]["title"].string!
                    let description = subJson["obj"]["description"].string!
                    let userId = subJson["obj"]["owner"].string!
                    let catId = subJson["obj"]["category"].string!
                    let lat = subJson["obj"]["address"]["coordinates"][1].double!
                    let long = subJson["obj"]["address"]["coordinates"][0].double!
                    
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
                    
                    let cat = Category(id: catId, title: "", imageURL: "")
                    let item = Item(
                        id: id,
                        title: title,
                        description: description,
                        imageURL: "http://google.dk/logo.png",
                        createdAt: NSDate(),
                        owner: user,
                        latitude: lat,
                        longitude: long,
                        category: cat
                    )
                    
                    items.append(item)
                }
                
                completion(items)
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    

    func getItems(category: Category?, completion: [Item] -> Void) {
        
        var items: [Item] = []
        
        var parameters: [String : AnyObject] = [:]
        
        if category != nil {
            parameters["categoryId"] = category?.id
        }

        Alamofire.request(.GET, "http://gratisting.dev:3000/api/v1/items", parameters: parameters, encoding: .URL).responseJSON { (response) in
            switch response.result {
            case .Success:
                print("success")
                let jsonData = JSON(data: response.data!)
                print(jsonData["success"].bool!)
                if jsonData.isEmpty {
                    print("empty")
                }
                
                if let subJson = jsonData["success"].bool {
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
                    
                    completion(items)
                }
                
            case .Failure(let error):
                print(error)
            }
        }
//        let jsonString = response.result.value
//        
//        // If nothing is returned, return an empty array
//        if(jsonString == nil) {
//            return []
//        }
//        
//        // Jsonify
//        let json = JSON(jsonString!)
//        
//        var items: [Item] = []
//        
//        let coords: [[Double]] = [[55.71, 12.51], [55.72, 12.52], [55.73, 12.53], [55.70, 12.52], [55.76, 12.53], [55.74, 12.52]]
//        
//        let address = Address(address: "Lygten 57", cityName: "Copgenhagen", postalCode: 2400, latitude: 55.51, longitude: 12.71)
//        let user = User(id: "1", email: "jonsnow@example.com", name: "Jon", address: address)
//        let category = Category(id: "abc", title: "Elektronik", imageURL: "http://placehold.it/350x150")
//        
//        for (index,data):(String, JSON) in json["data"] {
//            let id          = data["_id"].string!
//            let title       = data["title"].string!
//            let description = data["description"].string!
//            
//            
//            let item = Item(id: id, title: title, description: description, imageURL: "", createdAt: NSDate(), owner: user, latitude: coords[Int(index)!][0], longitude: coords[Int(index)!][1], category: category)
//            
//            items.append(item)
//        }
//        
//        return items
    }
    
    // Function for persisting a user
    func createUser(user: User) {
        
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
            switch response.result {
                
            case .Success:
                print("success")
                let jsonData = JSON(data: response.data!)
                print(jsonData)
                if jsonData.isEmpty {
                    print("empty")
                }
                for (_, subJson) in jsonData {
                    print(subJson)
                }
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    /**
     Method for creating item. (User authentication required to call).
     */
    func createItem(item: Item, token: String) {
        
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
        
        Alamofire.request(.POST, "http://localhost:3000/api/v1/items", parameters: (parameters as! [String : AnyObject]), encoding: .JSON, headers: headers).responseJSON { (response) in
            switch response.result {
                
            case .Success:
                let jsonData = JSON(data: response.data!)
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func getUser(userId: String, completion: (error: NSError?, user: User?) -> ()) {
        
        Alamofire.request(.GET, "http://gratisting.dev:3000/api/v1/users/" + userId).responseJSON { (response) in
            let jsonString = response.result.value
            
            let jsonData = JSON(jsonString!)
            
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
            
            completion(error: nil, user: user)
        }
        
    }
    
    
}

