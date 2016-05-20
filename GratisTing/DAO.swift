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

    func getAllCategories() -> [Category] {
        let response = Alamofire.request(.GET, "http://gratisting.dev:3000/api/v1/categories").responseJSON()
        let jsonString = response.result.value
        
        if jsonString == nil {
            return []
        }
        
        let json = JSON(jsonString!)
        
        var categories: [Category] = []
        
        for (_,data):(String, JSON) in json {
            print(data)
            let id          = String(data["id"].int!)
            let title       = data["name"].string!
            let image = "http://schneeblog.com/wp-content/uploads/2013/08/blank.jpg"
            
            let category = Category(id: id,title: title)
            category.imageURL = image
            
            categories.append(category)
        }
        
        return categories
    }
    
    func getItemsByCategory(category: Category?, latitude: Double, longitude: Double) -> [Item] {
        let response = Alamofire.request(.GET, "http://gratisting.dev:3000/api/v1/items").responseJSON()
        let jsonString = response.result.value
        
        // If nothing is returned, return an empty array
        if(jsonString == nil) {
            return []
        }
        
        // Jsonify
        let json = JSON(jsonString!)
        
        var items: [Item] = []
        
        let coords: [[Double]] = [[55.71, 12.51], [55.72, 12.52], [55.73, 12.53], [55.70, 12.52], [55.76, 12.53], [55.74, 12.52]]
        
                
        return items
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
                    print(subJson)                }
                
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
                print("success")
                let jsonData = JSON(data: response.data!)
                print(jsonData)
                if jsonData.isEmpty {
                    print("empty")
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func getUser(userId: String, completion: (error: NSError?, user: User?) -> ()) {
        
        Alamofire.request(.GET, "http://gratisting.dev:3000/api/v1/users/" + userId).responseJSON { (response) in
            let jsonString = response.result.value
            
            let jsonData = JSON(jsonString!)
            //print(jsonData)
            
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

