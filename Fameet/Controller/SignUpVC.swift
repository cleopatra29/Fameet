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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var signUpScrollView: UIScrollView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var firstNameLine: UIView!
    @IBOutlet weak var dobLine: UIView!
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var passwordLine: UIView!
    @IBOutlet weak var lastNameLine: UIView!
    
    //MARK : INITIALIZER
    var timestamp = Double()
    private var datePicker : UIDatePicker?
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    let userDefault = UserDefaults.standard
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func textFieldDelegate() {
        nameTF.delegate = self
        lastNameTF.delegate = self
        dateOfBirthTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    //MARK : BUTTON ACTION
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
//                endIndicatorView()
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                print("Some text field is empty.")
                return
        }
        
        signUp(email: emailTF.text!, password: passwordTF.text!, firstName: nameTF.text!, lastName: lastNameTF.text!, birthday: dateOfBirthTF.text!)
//        performSegue(withIdentifier: "toSignIn", sender: self)
        
        

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
            
            let dict : [String: Any] = [ "email" : email, "password" : password, "first-name" : firstName, "last-name" : lastName, "birthday" : birthday]
            Firestore.firestore().collection("user-collection").document(userID).setData(dict)
        }
        let alertDone = UIAlertController(title: "Success", message: "You successfully create an Account", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.signIn(email: email, password: password)
        }
        
        alertDone.addAction(action)
        self.present(alertDone, animated: true, completion: nil)
    }
    
    func signIn(email:String, password:String){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                if error?._code == AuthErrorCode.userNotFound.rawValue {
                    
                    let alertController = UIAlertController(title: "Oops!", message: "Your email or password is not true.", preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        
                        // Code in this block will trigger when OK button tapped.
                        print("Ok button tapped");
                        
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    print("User Belum Terdaftar")
                } else {
                    //AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    print(error)
                    print(error?.localizedDescription)
                }
                return
            }
            if error == nil {
                print("BERHASIL SIGN IN")
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()
                self.showHomeController()
            }
            
        })
    }
    
    func showHomeController() {
        let homeViewController: UIViewController = UIStoryboard(name: "Feature", bundle: nil).instantiateViewController(withIdentifier: "HomeViewTab") as UIViewController
        present(homeViewController, animated: true)
        endIndicatorView()
    }
    
    func endIndicatorView() {
    activityIndicator.stopAnimating()
    UIApplication.shared.endIgnoringInteractionEvents()
    }
    
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
    
    // MARK : TextField Highlight
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTF {
            firstNameLine.backgroundColor = .highLightColor
        } else if textField == lastNameTF {
            lastNameLine.backgroundColor = .highLightColor
        } else if textField == dateOfBirthTF {
            dobLine.backgroundColor = .highLightColor
        } else if textField == emailTF {
            emailLine.backgroundColor = .highLightColor
        } else if textField == passwordTF {
            passwordLine.backgroundColor = .highLightColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTF {
            firstNameLine.backgroundColor = .lightGray
        } else if textField == lastNameTF {
            lastNameLine.backgroundColor = .lightGray
        } else if textField == dateOfBirthTF {
            dobLine.backgroundColor = .lightGray
        } else if textField == emailTF {
            emailLine.backgroundColor = .lightGray
        } else if textField == passwordTF {
            passwordLine.backgroundColor = .lightGray
        }
    }

    
    func buttonDesign(){
        confirmButton.shappingButton()
        confirmButton.alpha = 0.5
        [nameTF, lastNameTF, dateOfBirthTF, emailTF, passwordTF].forEach({$0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)})
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
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDelegate()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(SignUpVC.datePickerValueChanged(sender:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        dateOfBirthTF.inputView = datePicker
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        // INI GK BISA DI SIMULATOR TAPI BISA DI KEYBOARD
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        buttonDesign()
    }
    

}

// MARK: UITextFieldDelegate
extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.signUpScrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
    
}

// MARK: Keyboard Handling
extension SignUpVC {
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.contentHeight.constant += self.keyboardHeight
            })
            
            // move if keyboard hide input field
            let distanceToBottom = self.signUpScrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            
            if collapseSpace < 0 {
                // no collapse
                return
            }
            
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.signUpScrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.contentHeight.constant -= self.keyboardHeight
            self.signUpScrollView.contentOffset = self.lastOffset
        }
        
        keyboardHeight = nil
    }
}

