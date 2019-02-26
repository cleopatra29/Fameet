//
//  CommitmentVC.swift
//  FinalChallengeVessel
//
//  Created by Christian Limansyah on 03/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CommitmentVC: UIViewController {
    
    let MasterUser = Auth.auth().currentUser?.uid as! String

    @IBOutlet weak var yourCommitment: UILabel!
    @IBOutlet weak var userNameLbh: UILabel!
    @IBOutlet weak var commitmentField: UITextField!
    @IBOutlet weak var commitmentDays: UITextField!
    
    @IBOutlet weak var updateBtn: UIButton!
    
    var memberList = [UserCollection]()
    var memberId = selectedFamMemberId
    var memberName = selectedFamMemberName
    var famGroup = selectedFamGroup //buat back
    var selectedTextField = UITextField()
    var picker = UIPickerView()
    
    
    var activities : [String] = ["Meet" ,"Call"]
    var days: [String] = ["1x", "2x", "3x", "4x", "5x", "6x", "7x"]

    
    @IBAction func updateBtns(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("family-collection").document("apple-fam").collection("family-member").document("xEXBC3eEtBSOtOemqYIiseWeD613").collection("commitment").document("r8ba22geQ4OwlmQ4kIyC1bgOQGR2").setData([
            "event" : "Meet",
            "times" : "Tiap hari bangsat"])
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        }
    
    //buat back
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let target = segue.destination as? FamilyVC else {return}
        target.MasterFamily = famGroup as String
    }
    
    //BELOM GW LANJUTIN PASSING DATA.
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLbh.text = memberId
        
        // Do any additional setup after loading the view.
    }
    
}




extension CommitmentVC: UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectedTextField == commitmentField{
            print("commitment numberofRow")
            return activities.count
        }else if selectedTextField == commitmentDays{
            print("days number of Row")
            return days.count
        }else{
            return 0
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedTextField == commitmentField{
            print("commitment title")
            return activities[row]
            
        }else if selectedTextField == commitmentDays{
            print("days title")
            
            return days[row]
            
        }else{
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedTextField == commitmentField{
            commitmentField.text = activities[row]
            self.view.endEditing(true)
            print("selected activity")
        }else if selectedTextField == commitmentDays{
            commitmentDays.text = days[row]
            self.view.endEditing(true)
            print("selected days")
        }else{
            print("selected none")
            self.view.endEditing(true)
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("penceted")
        picker.delegate = self
        picker.dataSource = self
        selectedTextField = textField
        if selectedTextField == commitmentField{
            print("activ picker")
            commitmentField.inputView = picker
        }else if selectedTextField == commitmentDays{
            print("days picker")
            commitmentDays.inputView = picker
            
        }
    }
}

