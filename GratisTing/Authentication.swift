//
//  Authentication.swift
//  GratisTing
//
//  Created by Thomas Attermann on 19/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Authentication {
    
    static let instance = Authentication()
    
    var jwt: String?
    
    var token = NSUserDefaults.standardUserDefaults()
    var user: User?
    
    // Authentication of user credentials
    func authenticate(email: String, password: String, completion: (error: NSError?, jwt: String?) -> () ) {
        
        let parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(.POST, "http://localhost:3000/api/v1/authenticate", parameters: parameters, encoding: .JSON).responseJSON { (response) in
            switch response.result {
                
            case .Success:
                var jsonData = JSON(data: response.data!)
                if let token = jsonData["data"]["token"].string {
                    // Token
                    self.jwt = token
                    
                    // User
                    let id = jsonData["data"]["user"]["_id"].string!
                    let email = jsonData["data"]["user"]["email"].string!
                    let name = jsonData["data"]["user"]["name"].string!
                    
                    print(jsonData["data"]["user"]["address"]["coordinates"])
                    
                    // Address
                    let address = jsonData["data"]["user"]["address"]["address"].string!
                    let cityName = jsonData["data"]["user"]["address"]["cityName"].string!
                    let postalCode = jsonData["data"]["user"]["address"]["postalCode"].int!
                    let lat = jsonData["data"]["user"]["address"]["coordinates"][0].double!
                    let long = jsonData["data"]["user"]["address"]["coordinates"][1].double!
                    let completeAddress = Address(address: address, cityName: cityName, postalCode: postalCode, latitude: lat, longitude: long)

                    
                    
                    self.user = User(id: id, email: email, name: name, address: completeAddress)
                    
                    completion(error: nil, jwt: token)
                } else {
                    let testError = NSError(domain: "Invalid credentials", code: 400, userInfo: [:])
                    
                    completion(error: testError, jwt: "")
                }
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func setToken(token: String) {
        self.token.setObject(token, forKey: "token")
    }
    
    func getToken() -> String{
        if token.objectForKey("token") != nil {
            return token.objectForKey("token")! as! String
        }
        return ""
    }
}