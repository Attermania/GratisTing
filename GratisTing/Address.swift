//
//  Address.swift
//  GratisTing
//
//  Created by Steffen on 18/05/16.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation

class Address {
    
    let address: String
    let cityName: String
    let postalCode: Int
    let latitude: Double
    let longitude: Double

    init(address: String, cityName: String, postalCode: Int, latitude: Double, longitude: Double) {
        self.address = address
        self.cityName = cityName
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
    }
}