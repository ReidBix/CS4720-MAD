//
//  Reminder.swift
//  RemindMe
//
//  Created by Reid Bixler on 2/21/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//

import UIKit

class Reminder {
    // MARK: Properties
    
    var title: String
    var description: String
    var dateTime: NSDate


    // MARK: Initialization
    
    init?(title: String, description: String, dateTime: NSDate) {
        // Initialize stored properties.
        self.title = title
        self.description = description
        self.dateTime = dateTime
        
        // Initialization should fail if there is no title
        if title.isEmpty{
            return nil
        }
    }

}




