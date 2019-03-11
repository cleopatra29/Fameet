//
//  HomeViewController.swift
//  iCal
//
//  Created by Jansen Malvin on 14/01/19.
//  Copyright © 2019 Jansen Malvin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn
import FirebaseAuth
import UserNotifications

class HomeVC: UIViewController {
    
    //MARK : OUTLET
    @IBOutlet weak var youtFamilyLbl: UILabel!
    @IBOutlet weak var homeTableViewOutlet: UITableView!
    @IBOutlet weak var dontHaveFamilyLabel: UILabel!
    //MARK : INITIALIZER
    let MasterUser : String = (Auth.auth().currentUser?.uid)!
    var MasterUserFamily = [FamilyCollection]()
    let userEmail = Auth.auth().currentUser?.email
    let userDefault = UserDefaults.standard
    var userFamId = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.image = UIImage(named: "home")
        setupView()
        //guard let userEmail = Auth.auth().currentUser?.email else { return }
        readUserFamilyGroup()
        // Do any additional setup after loading the view.
    }
    
    
    func setupView() {
        if MasterUserFamily.count == 0 {
            dontHaveFamilyLabel.isHidden = true
        } else {
            dontHaveFamilyLabel.isHidden = false
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        homeTableViewOutlet.tableFooterView = UIView()
    }
    
    func fetchFamilyCollection(id:String) {
        Firestore.firestore().collection("family-collection").document(id).getDocument (completion: {(snapshot, error) in
            
            if error != nil{
                return print(error!)
            } else {
                guard let fetchFamId = snapshot?.documentID, // as? String,
                    let fetchFamName = snapshot?.data()?["family-name"] as? String
                    else {return}
                self.MasterUserFamily.append(FamilyCollection(familyId: fetchFamId, familyName: fetchFamName))
                self.homeTableViewOutlet.reloadData()
            }
            print(self.readUserFamilyGroup)
        })
        
    }
    
    func readUserFamilyGroup() {
        Firestore.firestore().collection("user-collection").document(MasterUser).collection("family-group").getDocuments (completion: { (snapshot, error) in
            if error != nil{
                return print(error!)
            } else {
                for docFamRef in snapshot!.documents {
                    let famRefId = (docFamRef.data()["family-group-name"] as! DocumentReference).documentID 
                    print(famRefId)
                    self.userFamId.append(famRefId)
                }
                for x in self.userFamId {
                    self.fetchFamilyCollection(id: x)
                }
            }
        })
        
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        guard let target = segue.destination as? FamilyVC,
//            let isIndex = sender as? Int,
//            let idIndex = MasterUserFamily[isIndex].familyId as? String else {return false }
//        return true
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let target = segue.destination as? FamilyVC,
            let isIndex = sender as? Int,
            let idIndex = MasterUserFamily[isIndex].familyId as? String else {return}
        print("isIndex = \(isIndex)")
        target.MasterFamily = idIndex
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            try GIDSignIn.sharedInstance()?.signOut()
            userDefault.removeObject(forKey: "usersignedin")
            userDefault.synchronize()
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            print (signOutError.localizedDescription)
        }
    }
    
}


extension HomeVC: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            if indexPath.section == 0 {
                let delete = UITableViewRowAction(style: .destructive, title: "Leave Family") { (action, indexPath) in
                    let leaveFamilyConfimation = UIAlertController(title: "Confirm Leave Family", message: "Are you sure you want to leave this family group?", preferredStyle: .alert)
                    // Kalo di delete, masukin kodingan yang ilangin member di database di firebasenya
                    let leaveAction = UIAlertAction(title: "Yes", style: .default, handler: { (leave) in
                    self.MasterUserFamily.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancel) in
                    print("Cancel")
                })
                leaveFamilyConfimation.addAction(leaveAction)
                leaveFamilyConfimation.addAction(cancelAction)
                self.present(leaveFamilyConfimation, animated: true, completion: nil)
            }
            delete.backgroundColor = .red
            return [delete]
        }
        return []

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return MasterUserFamily.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
            let row = indexPath.row
            if MasterUserFamily.count == 0 {
                cell.cellLabels.text = "You don't have any family group yet"
                return cell
            } else {
                cell.cellLabels.text = MasterUserFamily[row].familyName
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addFamilyCell", for: indexPath) as! AddNewFamilyViewCell
            cell.addNewFamily.text = "Add new Family"
            cell.subAddNewFamily.font = UIFont.italicSystemFont(ofSize: 13.0)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = tableView.indexPathForSelectedRow
        
        //        print("Current index path : \(index)")
        //        print("Current cell : \(currentCell)")
        
        
        switch (indexPath.section) {
        case 0:
            let currentCell = tableView.cellForRow(at: index!) as! HomeTableViewCell
            performSegue(withIdentifier: "Home-Family", sender: index?.row)
            tableView.deselectRow(at: index!, animated: true)
        default:
            let currentCell = tableView.cellForRow(at: index!) as! AddNewFamilyViewCell
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            
            
            
            let joinOption = UIAlertAction(title: "Join", style: .default) { (choosedJoin) in
                // Kalo klik join koding disini
        
                let alertController = UIAlertController(title: "Join New Group", message: "", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField(configurationHandler: { (textField: UITextField!) in
                    
                    
                    textField.placeholder = "Enter group code"
                    let OKAction = UIAlertAction(title: "Join", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                        guard let inputJoin = textField.text,
                            inputJoin != ""
                        else {
                            let alertController = UIAlertController(title: "Oops!", message: "Your code is Empty", preferredStyle: .alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                // Code in this block will trigger when OK button tapped.
                                print("Ok button tapped");
                            }
                            alertController.addAction(OKAction)
                            self.present(alertController, animated: true, completion: nil)
                            
                            print("Text field is empty.")
                            textField.text = ""
                            return
                        }
                        let userRef : DocumentReference = Firestore.firestore().document("user-collection/\(self.MasterUser)")
                    
                        let dictJoin : [String: Any] = ["family-member" : userRef]
                    
                        let joinFamily = Firestore.firestore().collection("family-collection").document(textField.text!).collection("family-member").document(self.MasterUser).setData(dictJoin)
                        let familyRef : DocumentReference = Firestore.firestore().document("family-collection/\(textField.text!)")
                        let dictJoin1 : [String: Any] = ["family-group-name": familyRef]
                    
                        Firestore.firestore().collection("family-collection").document(textField.text ?? "").getDocument { (document, error) in
                            if let doc = document, document!.exists {
                                Firestore.firestore().collection("user-collection").document(self.MasterUser).collection("family-group").document(textField.text!).setData(dictJoin1)
                                
                                
                                self.homeTableViewOutlet.reloadData()
                                print("join Ok button tapped")
                                
                                let alertDone = UIAlertController(title: "Success", message: "You successfully Join The Family", preferredStyle: .alert)
                                let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                    self.userFamId.removeAll()
                                    self.MasterUserFamily.removeAll()
                                    self.readUserFamilyGroup()
                                    self.homeTableViewOutlet.reloadData()
                                }
                                
                                alertDone.addAction(action)
                                self.present(alertDone, animated: true, completion: nil)
                                
                            } else {
                                print("Document does not exist")
                                
                                let alertDone = UIAlertController(title: "Failed", message: "Family not Found :(", preferredStyle: .alert)
                                let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                }
                                
                                alertDone.addAction(action)
                                self.present(alertDone, animated: true, completion: nil)
                            }
                        }
                        
                
                       
                    }
                        
                
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction!) in
                        print("Cancel button tapped")
                    })
                        
                    alertController.addAction(OKAction)
                    alertController.preferredAction = OKAction
                    alertController.addAction(cancelAction)
                        
                })
                self.present(alertController, animated: true, completion: nil)
                print("Join button alert")
            }
            
            
            let createOption = UIAlertAction(title: "Create", style: .default) { (choosedCreate) in
                /// kalo klik create koding disini
                
                let alertController = UIAlertController(title: "Create New Group", message: "", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField(configurationHandler: { (textField: UITextField!) in
                    
                    textField.placeholder = "Enter Group Name"
                    let OKAction = UIAlertAction(title: "Create", style: .default) { (action:UIAlertAction!) in
                        guard let inputFamName = textField.text,
                            inputFamName != ""
                            else {
                                let alertController = UIAlertController(title: "Oops!", message: "Your Family Name is Empty", preferredStyle: .alert)
                                
                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                    // Code in this block will trigger when OK button tapped.
                                    print("Ok button tapped");
                                }
                                alertController.addAction(OKAction)
                                self.present(alertController, animated: true, completion: nil)
                                
                                print("Text field is empty.")
                                textField.text = ""
                                return
                        }
                        // Code in this block will trigger when OK button tapped.
                        let userRef : DocumentReference = Firestore.firestore().document("user-collection/\(self.MasterUser)")
                        
                        let dictAdd : [String: Any] = ["family-name" : textField.text!]
                        let dictAdd1 : [String: Any] = ["family-member" : userRef]
                        
                        let famID = Firestore.firestore().collection("family-collection").addDocument(data: dictAdd)
                        
                        famID.collection("family-member").document(self.MasterUser).setData(dictAdd1)
                        
                        let familyRef : DocumentReference = Firestore.firestore().document("family-collection/\(famID.documentID)")
                        
                        let dictAdd2 : [String: Any] = ["family-group-name": familyRef]
                        
                        Firestore.firestore().collection("user-collection").document(self.MasterUser).collection("family-group").document(famID.documentID).setData(dictAdd2)
                        print("create Ok button tapped")
                        
                        let alertDone = UIAlertController(title: "Success", message: "You successfully Create a Family", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                            self.userFamId.removeAll()
                            self.MasterUserFamily.removeAll()
                            self.readUserFamilyGroup()
                            self.homeTableViewOutlet.reloadData()
                        }
                        alertDone.addAction(action)
                        self.present(alertDone, animated: true, completion: nil)
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction!) in
                        print("Cancel button tapped")
                    })
                    alertController.addAction(OKAction)
                    alertController.preferredAction = OKAction
                    alertController.addAction(cancelAction)

                })
                self.present(alertController, animated: true, completion: nil)
                print("Create button alert")
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (canceled) in
                // kalo user cancel
                print("Cancel That")
            }
            
            optionMenu.addAction(joinOption)
            optionMenu.addAction(createOption)
            optionMenu.addAction(cancelButton)
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
}


