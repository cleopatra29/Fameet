//
//  ConfirmedViewCell.swift
//  Fameet
//
//  Created by Jansen Malvin on 05/03/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit

class ConfirmedViewCell: UITableViewCell {

    @IBOutlet weak var eventLBL: UILabel!
    @IBOutlet weak var dateConfirmLBL: UILabel!
    @IBOutlet weak var locationLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
