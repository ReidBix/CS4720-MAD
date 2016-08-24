//
//  BeerItem.swift
//  BeerMe
//
//  Created by Reid Bixler on 4/28/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//

import UIKit

class BeerItem {
    // MARK: Properties
    
    var name: String
    var id: String
    var abv: String
    var ibu: String
    
    // MARK: Initialization
    
    init?(name: String, id: String, abv: String, ibu: String) {
        // Initialize stored properties.
        self.name = name
        self.id = id
        self.abv = abv
        self.ibu = ibu
        
        // Initialization should fail if there is no title
        if name.isEmpty{
            return nil
        }
    }
    
}




