//
//  DAOProtocol.swift
//  GratisTing
//
//  Created by Thomas Attermann on 12/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import Foundation

protocol DAOProtocol {
    
    func getAllItems() -> [Item]
    
    func getAllCategories() -> [Category]
    
    func initDummyData() -> Void
    
}