//
//  UserProfileVC.swift
//  FinalChallengeVessel
//
//  Created by Christian Limansyah on 14/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseFirestore
import FirebaseUI
import FirebaseAuth

class UserProfileVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    //MARK : OUTLET
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayNameTF: UITextField!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var dobPicker: UITextField!
    
    //MARK : INITIALIZER
    let MasterUser:String = (Auth.auth().currentUser?.uid)!
    var imageRef : StorageReference {
        return Storage.storage().reference().child("userProfilePicture").child("\(MasterUser).jpg")
    }
    let userDefault = UserDefaults.standard
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var pressedTextField = UITextField()
    var pickerClicked = UIPickerView()
    //var changedFirstName = ""
    
    //MARK : BUTTON ACTION
    @IBAction func logOutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            try GIDSignIn.sharedInstance()?.signOut()
            userDefault.removeObject(forKey: "usersignedin")
            userDefault.synchronize()
            self.dismiss(animated: true, completion: nil)
            print("Logged out button pressed.")
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            print (signOutError.localizedDescription)
        }
        performSegue(withIdentifier: "loggedOut", sender: self)
        indicatorView()
    }
    
    @IBAction func changeImageBtn(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func changeImage(_ sender: Any) {
        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference().child("userProfilePicture").child("\(MasterUser).jpg")
        let uploadData = profileImage.image
        let nani = uploadData?.jpegData(compressionQuality: 0.3)
        
        storageRef.putData(nani!, metadata: nil) { (metadata, error) in
            if error != nil {
                print("error")
            }
            self.alerts()
            print("metaData : \(metadata)")
        }
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("user-collection").document(MasterUser).updateData(["first-name" : displayNameTF.text]) //setData(["first-name": displayNameTF.text])
    }
    
    
    //MARK : FUNCTIONS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        endIndicatorView()
    }
    
    func alerts() {
        let alertController = UIAlertController(title: "", message: "You successfully upload your photo.", preferredStyle: .alert)
        
        
        let OKAction = UIAlertAction(title: "Noice", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("image picker controller canceled")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Info : \(info)")
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
            print("edited image size : \((editedImage as! UIImage).size)")
        }
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
            print("Original Image Size : \(((originalImage as! UIImage).size))")
        }
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
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
    
    func showUserInfo() {
        let db = Firestore.firestore()
        db.collection("user-collection").document(MasterUser).getDocument { (snapshot, error) in
            if error != nil{
                print("error in loading user info")
            }else{
                self.displayNameTF.text = snapshot?.data()?["first-name"] as? String
                self.emailLbl.text = snapshot?.data()?["email"] as? String
//                self.dobLbh.text = snapshot?.data()?["birthday"] as? String
                print("master user show : \(self.MasterUser)")
                print("show user info name : \(snapshot?.data()?["first-name"] as? String)")
            }
        }
    }
    
    override func viewDidLoad() {
        if profileImage.image == nil{
        profileImage.image = UIImage(named: "boy")
        }
        showUserInfo()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

