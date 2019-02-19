//
//  NotificationVC.swift
//  FinalChallengeVessel
//
//  Created by Christian Limansyah on 15/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    //MARK : OUTLET
    @IBOutlet weak var comingSoonImage: UIImageView!
    
    override func viewDidLoad() {
        comingSoonImage.image = UIImage(named: "ComingSoon")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - External Resource References

     COMING SOON ICON :
     <div>Icons made by <a href="https://www.flaticon.com/authors/ddara" title="dDara">dDara</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
    */

}
