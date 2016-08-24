//
//  Beer.swift
//  4720Final
//
//  Created by Reid Bixler on 4/18/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//

import Foundation
import CoreData

@objc(Beer) class Beer: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var id: String
    @NSManaged var abv: String
    @NSManaged var ibu: String
}