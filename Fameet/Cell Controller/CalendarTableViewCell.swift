//
//  CalendarTableViewCell.swift
//  FinalChallengeVessel
//
//  Created by Terretino on 31/01/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var datePicked: UILabel!
    @IBOutlet weak var monthPicked: UILabel!    
    @IBOutlet weak var yearPicked: UILabel!
    @IBOutlet weak var datePickedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
