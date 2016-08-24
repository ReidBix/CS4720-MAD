//
//  Person.swift
//  4720Final
//
//  Created by Reid Bixler on 4/18/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//

import Foundation
import CoreData

@objc(Person) class Person: NSManagedObject {
    
    @NSManaged var age: NSNumber
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    
}