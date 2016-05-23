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
    var token: String? {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
        }
    }
    
    private init() {
        self.token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
        
        if let userId = getUserIdFromToken() {
            dao.getUser(userId) { (user: User?, error: NSError?) in
                if let _ = error {
                    // An error occured, abort ship
                    self.user = nil
                    self.token = nil
                    return
                }
                
                self.user = user
            }
        }
    }
    
    // MARK: Authenticate
    func authenticate(email: String, password: String, completion: (token: String?, user: User?, error: NSError?) -> () ) {
        
        dao.authenticate(email, password: password) { (token, user, error) in
            if let _ = error {
                // there was an error, abort the ship
                completion(token: nil, user: nil, error: error)
                return
            }
            
            self.user  = user
            self.token = token
            completion(token: token, user: user, error: nil)
        }
        
    }
    
    // MARK: Logout
    func logout() {
        self.user  = nil
        self.token = nil
    }
    
    // MARK: Get the authenticated users id from the token, stored in user defaults
    private func getUserIdFromToken() -> String? {
        
        let components = token?.componentsSeparatedByString(".")
        
        if components == nil || components!.count != 3 {
            return nil
        }
        
        let decodedData = base64decode(components![1])
        
        if decodedData == nil {
            return nil
        }
        
        let json = JSON(data: decodedData!)
        let id = json["_id"].string
        
        if(id == nil) {
            return nil
        }
        
        return String(id!)
    }
    
    /// URI Safe base64 decode
    private func base64decode(input:String) -> NSData? {
        let rem = input.characters.count % 4
        
        var ending = ""
        if rem > 0 {
            let amount = 4 - rem
            ending = String(count: amount, repeatedValue: Character("="))
        }
        
        let base64 = input.stringByReplacingOccurrencesOfString("-", withString: "+", options: NSStringCompareOptions(rawValue: 0), range: nil)
            .stringByReplacingOccurrencesOfString("_", withString: "/", options: NSStringCompareOptions(rawValue: 0), range: nil) + ending
        
        return NSData(base64EncodedString: base64, options: NSDataBase64DecodingOptions(rawValue: 0))
    }

}