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
        signInButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        signInButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.5)
        signInButton.layer.shadowOpacity = 0.8
        signInButton.layer.shadowRadius = 0.0
        signInButton.layer.masksToBounds = false
        signInButton.layer.cornerRadius = 4.0
    }
    
    override func viewDidLoad() {
        buttonDesign()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    func signIn(email: String, password: String) {
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
                self.performSegue(withIdentifier: "Login-Home", sender: self)
            }
            
        })
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
    
    @IBAction func signUpTapped(_ sender: Any) {
        
       
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        guard let email = emailTF.text,
            email != "",
            let password = passwordTF.text,
            password != ""
            else {
                let alertController = UIAlertController(title: "Oops!", message: "Your email or password is not true.", preferredStyle: .alert)
                
                
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
        
       // indicatorView()

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // endIndicatorView()
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
