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

    @IBOutlet weak var eventNameTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    
    var EventId = String()
    var MasterUser = Auth.auth().currentUser?.uid as! String
    var MasterFamily = String()
    
    func formAct(eventName:String) {
        let userRef : DocumentReference = Firestore.firestore().document("user-collection/\(self.MasterUser)")
        
        let dictAdd : [String: Any] = ["event-name" : eventName]
        
    
        Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").document(EventId).getDocument { (document, error) in
            if document!.exists {
                Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").document(self.EventId).setData(dictAdd)
                Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").document(self.EventId).collection("joined-member").document(self.MasterUser).setData(["status" : "admin"])
                print("data created")
            } else {
                Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").document(self.EventId).collection("joined-member").document(self.MasterUser).setData(["status" : "member"])
                print("joined")
            }
        }
        
    }
    @IBAction func confirmBTN(_ sender: Any) {
        formAct(eventName: eventNameTF.text!)
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
