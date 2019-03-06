//
//  ConfirmedTimeVC.swift
//  Fameet
//
//  Created by Jansen Malvin on 05/03/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ConfirmedTimeVC: UIViewController {

    var EventId = String()
    var MasterUser = String()
    var MasterFamily = String()
    
    func formAct(eventName:String,location:String) {
        Firestore.firestore().collection("family-collection").document(MasterFamily).collection("event-collection").document(EventId).setData([
            "event-name" : eventName,
            "event-location" : location])
        //Firestore.firestore().collection("family-collection").document(MasterFamily).collection("event-collection").document(EventId).
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
