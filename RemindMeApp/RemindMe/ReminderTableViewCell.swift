//
//  ReminderTableViewCell.swift
//  RemindMe
//
//  Created by Reid Bixler on 2/21/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   

}
