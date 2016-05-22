//
//  Item.swift
//  GratisTing
//
//  Created by Thomas Attermann on 11/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation
import MapKit

class Item {
    
    var id: String = ""
    var title: String = ""
    var description: String = ""
    var imageURL: String = ""
    var createdAt: NSDate = NSDate()
    var owner: User?
    var category: Category?
    var address: Address?
    var distance: Double = 0
    
    /*
     Constructor without id parameter. Used when creating Item object in the app. Id will be assigned in DB.
     */
    init (title: String, description: String, imageURL: String, owner: User, address: Address, category: Category) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.owner = owner
        self.address = address
        self.category = category
    }
    
    /**
     Constructor with id attribute. Used when parsing JSON to Item object.
     */
    init (id: String, title: String, description: String, imageURL: String, createdAt: NSDate, owner: User, address: Address, category: Category) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.createdAt = createdAt
        self.owner = owner
        self.address = address
        self.category = category
    }
    
    func getDistanceInKm(destLongitude: Double?, destLatitude: Double?) -> Double? {
        
        if destLongitude == nil || destLatitude == nil {
            return nil
        }
        let source = CLLocation(latitude: self.address!.latitude, longitude: self.address!.longitude)
        let dest = CLLocation(latitude: destLatitude!, longitude: destLongitude!)
        
        let distance = source.distanceFromLocation(dest) / 1000
        
        return distance
    }
    
}
