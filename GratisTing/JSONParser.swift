import Foundation
import SwiftyJSON

class JSONParser {
    
    // MARK: Parse items
    func parseItems(j: JSON) -> [Item] {
        var items: [Item]                   = []
        var users: [String : User]          = [:]
        var categories: [String : Category] = [:]
        
        // Parse users
        for (_, userJson) in j["relationships"]["users"] {
            
            // Parse user
            let user = self.parseUser(userJson)
            
            // Add user to dictionary
            if user != nil {
                users[user!.id] = user
            }
            
        }
        
        // Parse categories
        for (_, catJson) in j["relationships"]["categories"] {
            let category = self.parseCategory(catJson)
            
            if category != nil {
                categories[category!.id!] = category
            }
        }
        
        
        // Parse items
        for (_, subJson) in j["data"] {
            
            let userId = subJson["owner"].string!
            let catId  = subJson["category"].string!
            
            let item = self.parseItem(subJson, owner: users[userId]!, category: categories[catId]!)
            
            // Append item to list of items
            if item != nil {
                items.append(item!)
            }
        }
        
        return items
    }
    
    // MARK: Parse a single item
    func parseItem(j: JSON, owner: User, category: Category) -> Item? {
        
        do {
            
            // Parse item
            let id          = try s(j["_id"])
            let title       = try s(j["title"])
            let description = try s(j["description"])
            let address     = parseAddress(j["address"])
            
            // If there is no address, parsing has failed and we return nil
            if address == nil {
                return nil
            }
            
            // Return item
            return Item(
                id: id,
                title: title,
                description: description,
                imageURL: "",
                createdAt: NSDate(),
                owner: owner,
                address: address!,
                category: category
            )
            
        } catch {
            return nil
        }
        
    }
    
    // MARK: Parse a user
    func parseUser(j: JSON) -> User? {
        
        do {
            
            // Parse user
            let id    = try s(j["_id"])
            let email = try s(j["email"])
            let name  = try s(j["name"])
            
            // Parse Address
            let address = parseAddress(j["address"])
            
            if address == nil {
                return nil
            }
            
            // Return user
            return User(id: id, email: email, name: name, address: address!)
            
        } catch {
            
            // Return nil if user could not be parsed
            return nil
            
        }
        
    }
    
    // MARK: Parse a category
    func parseCategory(j: JSON) -> Category? {
        
        do {
            
            // Parse category
            let id    = try s(j["_id"])
            let title = try s(j["title"])
            let image = try s(j["image"])
            
            // Return category
            return Category(id: id, title: title, imageURL: image)
            
        } catch {
            
            // Return nil if category could not be parsed
            return nil
            
        }
        
    }
    
    // MARK: Parse an address
    func parseAddress(j: JSON) -> Address? {
        do {
            
            // Parse Address
            let streetAddress = try s(j["address"])
            let cityName      = try s(j["cityName"])
            let postalCode    = try i(j["postalCode"])
            let long          = try d(j["location"]["coordinates"][0])
            let lat           = try d(j["location"]["coordinates"][1])
            
            // Return address
            return Address(
                address:    streetAddress,
                cityName:   cityName,
                postalCode: postalCode,
                latitude:   lat,
                longitude:  long
            )
            
        } catch {
            
            // Return nil if address could not be parsed
            return nil
            
        }
    }
    
    // MARK: Return a string
    private func s(json: JSON) throws -> String {
        if json.string == nil {
            throw ParseError.NotString
        }
        
        return json.string!
    }
    
    // MARK: Return a double
    private func d(json: JSON) throws -> Double {
        if json.double == nil {
            throw ParseError.NotDouble
        }
        
        return json.double!
    }
    
    // MARK: Return an integer
    private func i(json: JSON) throws -> Int {
        if(json.int == nil) {
            throw ParseError.NotInt
        }
        
        return json.int!
    }
    
}


// MARK: Errors
enum ParseError: ErrorType {
    case NotString
    case NotDouble
    case NotInt
}