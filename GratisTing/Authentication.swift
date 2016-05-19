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
                
                if let token = jsonData["token"].string {
                    self.jwt = token
                    completion(error: nil, jwt: token)
                }
                let testError = NSError(domain: "Invalid credentials", code: 400, userInfo: [:])
                
                completion(error: testError, jwt: nil)
            case .Failure(let error):
                print(error)
            }
        }

        
    }
    
}