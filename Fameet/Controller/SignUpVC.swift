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

class SignUpVC: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate {
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
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    //MARK : SIGNUP BUTTON
    @IBAction func signUpAction(_ sender: Any) {
        guard let email = emailTF.text,
            email != "",
            let password = passwordTF.text,
            password != ""
            else {
                let alertController = UIAlertController(title: "Oops!", message: "Please fill the required information.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    print("Ok button tapped");
                }
                endIndicatorView()
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                print("Some text field is empty.")
                return
        }
        signUp(email: emailTF.text!, password: passwordTF.text!, firstName: nameTF.text!, lastName: lastNameTF.text!, birthday: dateOfBirthTF.text!)
        indicatorView()
        performSegue(withIdentifier: "toSignIn", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        endIndicatorView()
    }
    
    //MARK : REGISTER NEW USER TO DATABASE
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
    
    //MARK : TEXTFIELD EDIT
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let email = emailTF.text, !email.isEmpty,
            let password = passwordTF.text, !password.isEmpty
            else {
                confirmButton.isEnabled = false
                confirmButton.alpha = 0.5
                return
        }
        confirmButton.alpha = 1
        confirmButton.isEnabled = true
    }
    
    //MARK : BUTTON DESIGN
    func buttonDesign(){
        confirmButton.shappingButton()
        confirmButton.alpha = 0.5
        [nameTF, lastNameTF, dateOfBirthTF, emailTF, passwordTF].forEach({$0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)})
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    //MARK : DATEPICKER
    @objc func datePickerValueChanged(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateOfBirthTF.text = formatter.string(from: sender.date)
        
        timestamp = Date().timeIntervalSinceReferenceDate
        print("double format : \(timestamp)")
        
        print(formatter)
        print("string format : \(formatter.string(from: sender.date))")
    }
    
    //MARK : INDICATOR VIEW
    func indicatorView() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        activityIndicator.backgroundColor = UIColor.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    //MARK : END INDICATOR VIEW
    func endIndicatorView() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    //NIATNYA MAU BIKIN TAMPILAN LEBIH ENAK PAS LAGI NGETIK TEXTFIELD PAS KEYBOARD NONGOL
//    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
//        let moveDuration = 0.3
//        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
//
//        UIView.beginAnimations("animateTextField", context: nil)
//        UIView.setAnimationBeginsFromCurrentState(true)
//        UIView.setAnimationDuration(moveDuration)
//        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
//        UIView.commitAnimations()
//
//    }
//    //keyboard shows
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        moveTextField(textField: textField, moveDistance: -250, up: true)
//    }
//
//    //keyboard hidden
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        moveTextField(textField: textField, moveDistance: -250, up: false)
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(SignUpVC.datePickerValueChanged(sender:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        dateOfBirthTF.inputView = datePicker
        GIDSignIn.sharedInstance()?.uiDelegate = self
        buttonDesign()
    }
    

}
