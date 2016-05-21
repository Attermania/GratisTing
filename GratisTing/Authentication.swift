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
import JWT

class Authentication {
    
    static let instance = Authentication()
    let dao = AppDelegate.dao
    
    var user: User?
    
    private init() {
        if let userId = decodeTokenToUserId() {
            dao.getUser(userId) { (error, user) in
                self.user = user
            }
        }
    }
    
    // Authentication of user credentials
    func authenticate(email: String, password: String, completion: (error: NSError?, jwt: String?) -> () ) {
        
        let parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(.POST, "http://gratisting.dev:3000/api/v1/authenticate", parameters: parameters, encoding: .JSON).responseJSON { (response) in
            switch response.result {
                
            case .Success:
                var jsonData = JSON(data: response.data!)
                if let token = jsonData["data"]["token"].string {
                    // Token
                    self.setToken(token)
                    print("Set token" + token)
                    
                    // User
                    let id = jsonData["data"]["user"]["_id"].string!
                    let email = jsonData["data"]["user"]["email"].string!
                    let name = jsonData["data"]["user"]["name"].string!
                    
                    print(jsonData["data"]["user"]["address"]["coordinates"])
                    
                    // Address
                    let address = jsonData["data"]["user"]["address"]["address"].string!
                    let cityName = jsonData["data"]["user"]["address"]["cityName"].string!
                    let postalCode = jsonData["data"]["user"]["address"]["postalCode"].int!
                    let lat = jsonData["data"]["user"]["address"]["coordinates"][1].double!
                    let long = jsonData["data"]["user"]["address"]["coordinates"][0].double!
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
    
    /**
    Method for logging a user out. Set User object and NSUserdefault token as nil.
    */
    func logout() {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "token")
        self.user = nil
    }
    
    // Method for decoding token to resolve user ID
    func decodeTokenToUserId() -> String? {
        if let token = getToken() {
        
            let stringToDecode = token.substringWithRange(Range<String.Index>(start: getToken()!.startIndex.advancedBy(4), end: getToken()!.endIndex.advancedBy(0)))
            
            do {
                let payload = try JWT.decode(stringToDecode, algorithm: .HS256("secret"))
                let json = JSON(payload)
                
                return json["_id"].string!
            } catch {
                print("Failed to decode JWT: \(error)")
            }
        }
        
        return nil
    }
    
    func setToken(token: String) {
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
    }
    
    func getToken() -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
    }
}