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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        guard let target = segue.destination as? CalendarVC else {return}
        if let target = segue.destination as? FamilyVC {
            target.MasterFamily = MasterFamily as String
        }
    }
    
    @IBAction func doneBTN(_ sender: Any) {
        let dictAdd : [String: Any] = [ "event-name" : eventNameTF.text!, "location" : locationTF.text! ]
        
        
        Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").document(self.EventId).setData(dictAdd)
        
        Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").document(self.EventId).collection("joined-member").document(self.MasterUser).setData(["status" : "admin"])
        print("data created")
        
        
        
        navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "ConfirmedTime-Family", sender: (Any).self)
    }
    
    @IBAction func cancelBTN(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    

    func formAct(eventName:String, location:String) {
//        let userRef : DocumentReference = Firestore.firestore().document("user-collection/\(self.MasterUser)")
        
       
//        Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").document(self.EventId).collection("joined-member").document(self.MasterUser).setData(["status" : "member"])
//        print("joined")
        
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("master Family Confirm : \(MasterFamily)")
        print("event id : \(EventId)")
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
