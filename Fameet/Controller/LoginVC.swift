//
//  LoginViewController.swift
//  iCal
//
//  Created by Jansen Malvin on 10/01/19.
//  Copyright © 2019 Jansen Malvin. All rights reserved.
//

import UIKit
import FirebaseFirestore
import GoogleSignIn
import FirebaseAuth

class LoginVC: UIViewController, GIDSignInUIDelegate {

    //MARK : OUTLET
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK : INITIALIZER
    let userDefault = UserDefaults.standard
    var GIDSignUp = Bool()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    override func viewDidAppear(_ animated: Bool) {
//        if userDefault.bool(forKey: "usersignedin") {
//            performSegue(withIdentifier: "Login-Home", sender: self)
//        }
    }
    func buttonDesign(){
        signInButton.shappingButton()
    }
    
    
    override func viewDidLoad() {
        buttonDesign()
        super.viewDidLoad()
        signInButton.isEnabled = false
        signInButton.alpha = 0.5
        [emailTF, passwordTF].forEach({$0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)})
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                if error?._code == AuthErrorCode.userNotFound.rawValue {
                    
                    let alertController = UIAlertController(title: "Oops!", message: "Your email or password is incorrect.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        // Code in this block will trigger when OK button tapped.
                        print("Ok button tapped");
                    }
                    self.endIndicatorView()
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    print("User Belum Terdaftar")
                } else {
                    let alertController = UIAlertController(title: "Oops!", message: "Your email or password is incorrect.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        // Code in this block will trigger when OK button tapped.
                        print("Ok button tapped");
                    }
                    self.endIndicatorView()
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    print("pass salah")

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
            signInButton.isEnabled = false
            signInButton.alpha = 0.5
            return
        }
        signInButton.alpha = 1
        signInButton.isEnabled = true
    }
    
    func showHomeController() {
        let homeViewController: UIViewController = UIStoryboard(name: "Feature", bundle: nil).instantiateViewController(withIdentifier: "HomeViewTab") as UIViewController
        present(homeViewController, animated: true)
        endIndicatorView()
    }
    
    func indicatorView() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        activityIndicator.backgroundColor = UIColor.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func endIndicatorView() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        guard let email = emailTF.text,
            email != "",
            let password = passwordTF.text,
            password != ""
            else {
                let alertController = UIAlertController(title: "Oops!", message: "Your email or password is incorrect.", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped");
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                
                print("Text field is empty.")
                emailTF.text = ""
                passwordTF.text = ""
                return
        }
        signIn(email: emailTF.text!, password: passwordTF.text!)
        indicatorView()
        emailTF.text = ""
        passwordTF.text = ""

    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        endIndicatorView()
    }
}
