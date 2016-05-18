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
        let response = Alamofire.request(.GET, "http://localhost:3000/api/v1/categories").responseJSON()
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
    
    func getItemsByCategory(category: Category?, latitude: Double, longitide: Double) -> [Item] {
        let response = Alamofire.request(.GET, "http://localhost:3000/api/v1/items").responseJSON()
        let jsonString = response.result.value
        
        // If nothing is returned, return an empty array
        if(jsonString == nil) {
            return []
        }
        
        // Jsonify
        let json = JSON(jsonString!)
        
        var items: [Item] = []
        
        let coords: [[Double]] = [[55.71, 12.51], [55.72, 12.52], [55.73, 12.53], [55.70, 12.52], [55.76, 12.53], [55.74, 12.52]]
        
        let address = Address(address: "Lygten 57", cityName: "Copgenhagen", postalCode: 2400, latitude: 55.51, longitude: 12.71)
        let user = User(id: "1", email: "jonsnow@example.com", password: "secret", name: "Jon", address: address)
        let category = Category(id: "abc", title: "Elektronik")
        
        for (index,data):(String, JSON) in json["data"] {
            let id          = data["_id"].string!
            let title       = data["title"].string!
            let description = data["description"].string!
            
            
            let item = Item(id: id, title: title, description: description, imageURL: "", createdAt: NSDate(), owner: user, latitude: coords[Int(index)!][0], longitude: coords[Int(index)!][1], category: category)
            
            items.append(item)
        }
        
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
                "latitude": user.address.latitude,
                "longitude": user.address.longitude
            ]
        ]
        
        Alamofire.request(.POST, "http://localhost:3000/api/v1/users", parameters: parameters as! [String : AnyObject], encoding: .JSON).responseJSON { (response) in
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
}

