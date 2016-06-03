import Foundation
import Alamofire
import SwiftyJSON
import JWT

class Authentication {
    
    // MARK: Dependencies
    static let instance = Authentication()
    let dao = AppDelegate.dao
    
    // MARK: Instance variables
    
    // The authenticated user
    var user: User?
    
    // The token of the user
    var token: String? {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
        }
    }
    
    // MARK: Initializers
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
        
        // Authenticate through the DAO
        dao.authenticate(email, password: password) { (token, user, error) in
            if let _ = error {
                // there was an error, abort the ship
                completion(token: nil, user: nil, error: error)
                return
            }
            
            // Save the user and token
            self.user  = user
            self.token = token
            
            // Run the completion handler
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
        
        // Seperate the JWT sections
        let components = token?.componentsSeparatedByString(".")
        
        // If the jwt is not correctly formatted, abort the ship
        if components == nil || components!.count != 3 {
            return nil
        }
        
        // Base64 decode the payload section
        let decodedData = base64decode(components![1])
        
        // decoding went wrong, abort
        if decodedData == nil {
            return nil
        }
        
        // Get the id from the json string
        let json = JSON(data: decodedData!)
        let id = json["_id"].string
        
        if(id == nil) {
            return nil
        }
        
        // Return the id
        return String(id!)
    }
    
    /// URI Safe base64 decode
    private func base64decode(input:String) -> NSData? {
        // First we remove the possible url encoding from the string
        let rem = input.characters.count % 4
        
        var ending = ""
        if rem > 0 {
            let amount = 4 - rem
            ending = String(count: amount, repeatedValue: Character("="))
        }
        
        let base64 = input.stringByReplacingOccurrencesOfString("-", withString: "+", options: NSStringCompareOptions(rawValue: 0), range: nil)
            .stringByReplacingOccurrencesOfString("_", withString: "/", options: NSStringCompareOptions(rawValue: 0), range: nil) + ending
        
        // And now we decode the base64 string and return it
        return NSData(base64EncodedString: base64, options: NSDataBase64DecodingOptions(rawValue: 0))
    }

}