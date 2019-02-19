//
//  SignUpVC.swift
//  FinalChallengeVessel
//
//  Created by Christian Limansyah on 15/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class SignUpVC: UIViewController,GIDSignInUIDelegate {
    //MARK : OUTLET
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var dateOfBirthTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK : INITIALIZER
    var timestamp = Double()
    private var datePicker : UIDatePicker?
    
    //MARK : BUTTON ACTION
    @IBAction func signUpAction(_ sender: Any) {
        guard let email = emailTF.text,
            email != "",
            let password = passwordTF.text,
            password != ""
            else {
                _ = UIAlertController(title: "Oops! Something is Missing.", message: "Please fill your email or password.", preferredStyle: .alert)
                print("please fill textfield")
                return
        }
        signUp(email: emailTF.text!, password: passwordTF.text!, firstName: nameTF.text!, lastName: lastNameTF.text!, birthday: dateOfBirthTF.text!)
        performSegue(withIdentifier: "toPrelogin", sender: self)

    }
    
    //MARK : FUNCTIONS
    func signUp(email: String, password: String, firstName: String, lastName: String, birthday: String ){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard error == nil else {
                //AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                print(error)
                print(error?.localizedDescription)
                return
            }
            let userID = Auth.auth().currentUser?.uid as! String
            
            let db = Firestore.firestore()
            let dict : [String: Any] = [ "email" : email, "password" : password, "first-name" : firstName, "last-name" : lastName, "birthday" : birthday]
            db.collection("user-collection").document(userID).setData(dict)
        }
    }
    
    func buttonDesign(){
        confirmButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.5)
        confirmButton.layer.shadowOpacity = 0.8
        confirmButton.layer.shadowRadius = 0.0
        confirmButton.layer.masksToBounds = false
        confirmButton.layer.cornerRadius = 4.0
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateOfBirthTF.text = formatter.string(from: sender.date)
        
        timestamp = Date().timeIntervalSinceReferenceDate
        print("double format : \(timestamp)")
        
        print(formatter)
        print("string format : \(formatter.string(from: sender.date))")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(SignUpVC.datePickerValueChanged(sender:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        dateOfBirthTF.inputView = datePicker
        GIDSignIn.sharedInstance()?.uiDelegate = self

        // Do any additional setup after loading the view.
    }
    

}
