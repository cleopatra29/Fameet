//
//  CommitVC.swift
//  FinalChallengeVessel
//
//  Created by Christian Limansyah on 11/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CommitVC: UIViewController {

    //MARK : OUTLET
    @IBOutlet weak var navItemLbl: UINavigationItem!
    @IBOutlet weak var commitLbl: UILabel!
    @IBOutlet weak var mainTextLbl: UILabel!
    @IBOutlet weak var commitField: UITextField!
    @IBOutlet weak var commitDays: UITextField!
    
    //MARK : BUTTON
    @IBAction func saveBtn(_ sender: Any) {
        Firestore.firestore().collection("family-collection").document(famGroup).collection("family-member").document(MasterUser).collection("commitment").document(memberId).setData([
            "event" : tempSelectedCommitment,
            "times" : tempSelectedDays])
        
    }
    
    //MARK : Initializer
    let MasterUser = Auth.auth().currentUser?.uid as! String
    var memberList = [UserCollection]()
    var memberId = selectedFamMemberId
    var memberName = selectedFamMemberName
    var famGroup = selectedFamGroup
    var tempSelectedCommitment = ""
    var tempSelectedDays = ""
    var pressedTextField = UITextField()
    var picker = UIPickerView()
    
    
    //MARK : Arrays
    var activities : [String] = ["Meet" ,"Call"]
    var days: [String] = ["1", "2", "3", "4", "5", "6", "7"]
    
    //Back
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = famGroup
        navigationItem.backBarButtonItem = backItem
        guard let target = segue.destination as? FamilyVC else {return}
        target.MasterFamily = famGroup as String
        alerts()
        
    }
    
    func alerts() {
        let alertController = UIAlertController(title: "COMMITMENT", message: "You successfully make new commitment", preferredStyle: .alert)
        
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextLbl.text = "I want to meet Christian every "
        print("fam member Name : \(memberName)")
        print("fam group : \(famGroup)")
        print("member ID : \(memberId)")
        print("Master user : \(MasterUser)")
        
    }
}

extension CommitVC: UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pressedTextField == commitField{
            print("commitment numberofRow")
            return activities.count
        }else if pressedTextField == commitDays{
            print("days number of Row")
            return days.count
        }else{
            return 0
        }
    }
    
 
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pressedTextField == commitField{
            print("commitment title")
            return activities[row]
            
        }else if pressedTextField == commitDays{
            print("days title")
            
            return days[row]
            
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pressedTextField == commitField{
            commitField.text = activities[row]
            tempSelectedCommitment = activities[row]
            self.view.endEditing(true)
            print("tempSelectedCommitment : \(tempSelectedCommitment)")
        }else if pressedTextField == commitDays{
            commitDays.text = days[row]
            tempSelectedDays = days[row]
            self.view.endEditing(true)
            print("temp days : \(tempSelectedDays)")
        }else{
            print("selected none")
            self.view.endEditing(true)
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("penceted")
        picker.delegate = self
        picker.dataSource = self
        pressedTextField = textField
        if pressedTextField == commitField{
            print("activ picker")
            commitField.inputView = picker
        }else if pressedTextField == commitDays{
            print("days picker")
            commitDays.inputView = picker
        }
    }
}


