//
//  FamilyVC.swift
//  iCal
//
//  Created by Jansen Malvin on 01/02/19.
//  Copyright © 2019 Jansen Malvin. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseFirestore
//import GoogleSignIn
import FirebaseAuth
//import FirebaseStorage
import FirebaseUI
import MessageUI

var selectedFamMemberId :String = ""
var selectedFamMemberName:String = ""
//buat back
var selectedFamGroup: String = ""


class FamilyVC: UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var tableViewMatchDates: UITableView!
    @IBOutlet weak var memberCollectionOutlet: UICollectionView!
    @IBOutlet var skeletonViews: SkeletonView!
    
    
    let MasterUser = Auth.auth().currentUser?.uid as! String
    
    var famMemberId = [String]()
    var tempFamMemberList : [String] = []
    var famMemberList = [UserCollection]()
    
    var MasterFamily = String()
    var dateModel = DateModel()
    
    var datePicked = [NSDate]()
    var availMatchDate = [NSDate:[String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async(){
            self.readUserFamilyGroup()
        }
        fetchFamilyCollection(id: MasterFamily)
        memberCollectionOutlet.delegate = self
        memberCollectionOutlet.dataSource = self
        tableViewMatchDates.delegate = self
        tableViewMatchDates.dataSource = self
        
    }
    
    func setupView() {
        familyNameLabel.alpha = 0.0
        self.skeletonViews.setNeedsDisplay()
        self.skeletonViews.animating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.readUserFamilyGroup()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableViewMatchDates.reloadData()
    }
    
    func fetchFamilyCollection(id:String){
        Firestore.firestore().collection("family-collection").document(id).getDocument (completion: {(snapshot, error) in
            guard let fetchFamilyId = snapshot?.documentID as? String,
                let fetchFamilyName = snapshot?.data()!["family-name"] as? String
                else {return}
            self.familyNameLabel.text = "\(fetchFamilyName)'s Family"
        })
    }
    
    func fetchUserCollection(id:String) {
        Firestore.firestore().collection("user-collection").document(id).getDocument (completion: {(snapshot, error) in
            
            if error != nil{
                return print(error)
            } else {
                guard let fetchUserId = snapshot?.documentID as? String,
                    let fetchUserFirst = snapshot?.data()!["first-name"] as? String,
                    let fetchUserLast = snapshot?.data()!["last-name"] as? String,
                    let fetchEmail = snapshot?.data()!["email"] as? String,
                    let fetchPassword = snapshot?.data()!["password"] as? String,
                    let fetchBirthday = snapshot?.data()!["birthday"] as? String
                    
                    else {return}
                self.famMemberList.append(UserCollection(userId: fetchUserId, firstName: fetchUserFirst, lastName: fetchUserLast, email: fetchEmail, password: fetchPassword, birthday: fetchBirthday))
                
                
                
//                print(self.famMemberList)
//                print("famMember count : \(self.famMemberList.count)")
                self.memberCollectionOutlet.reloadData()
            }
            
        })
        
    }
    
    func readUserFamilyGroup() {
        Firestore.firestore().collection("family-collection").document(MasterFamily).collection("family-member").getDocuments (completion: { (snapshot, error) in
            if error != nil{
                return print(error)
            } else {
                for docUserRef in snapshot!.documents {
                    let userRefId = (docUserRef.data()["family-member"] as? DocumentReference)?.documentID as? String
                        print(userRefId)
                    
                    Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("family-member").document(userRefId!).collection("free-time").getDocuments(completion: { (snapshot1, error) in
                        if let err = error{
                            return print(err)
                        } else {
                            for freeTime in snapshot1!.documents{
                                guard let freeTimeId = freeTime.documentID as? String,
                                    let freeTimeDate = freeTime.data()["date"] as? Int,
                                    let freeTimeMonth = freeTime.data()["month"] as? Int,
                                    let freeTimeYear = freeTime.data()["year"] as? Int
                                    else {return}
                                
                                if freeTimeYear >= self.dateModel.presentYear {
                                    if freeTimeYear >= self.dateModel.presentYear || freeTimeMonth >= self.dateModel.presentMonthIndex {
                                        if freeTimeYear >= self.dateModel.presentYear || freeTimeMonth >= self.dateModel.presentMonthIndex || freeTimeDate >= self.dateModel.todaysDate {
                                            let datestring : NSDate = NSDate(dateString: "\(freeTimeDate)-\(freeTimeMonth)-\(freeTimeYear)")

                                            if self.availMatchDate[datestring]?.isEmpty == false {
                                                self.availMatchDate[datestring]?.append(userRefId!)
                                            } else {
                                                self.availMatchDate.updateValue([userRefId!], forKey: datestring)
                                            }
                                            self.tableViewMatchDates.reloadData()
                                            print(userRefId!)
                                    } else {
                                        Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("family-member").document(self.MasterUser).collection("free-time").document(freeTimeId).delete()
                                    }
                                } else {
                                    Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("family-member").document(self.MasterUser).collection("free-time").document(freeTimeId).delete()
                                }
                            } else {
                                Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("family-member").document(self.MasterUser).collection("free-time").document(freeTimeId).delete()
                                }
                            }
                        }
                    })
                    self.famMemberId.append(userRefId!)
                }
                for x in self.famMemberId {
                    self.fetchUserCollection(id: x)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    print(self.availMatchDate)
                })
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let target = segue.destination as? CalendarVC else {return}
        if let target = segue.destination as? CalendarVC {
            target.MasterFamily = MasterFamily as String
        } else if let target = segue.destination as? SendInvitationVC {
            target.MasterFamily = MasterFamily as String
        }
    }
    
    @IBAction func addFreeTimeAct(_ sender: Any) {
       navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension FamilyVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return famMemberList.count
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch(indexPath.section) {
        case 0:
            let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "famCell", for: indexPath) as! FamilyDetailCollectionViewCell
            

        
            // Reference to an image file in Firebase Storage
            let reference = Storage.storage().reference().child("userProfilePicture/\(famMemberList[indexPath.row].userId).jpg")
        
            collectionCell.memberName.text = famMemberList[indexPath.row].firstName
        
            collectionCell.memberImage.sd_setImage(with: reference, placeholderImage: UIImage(named: "boy"))
            print("image ref : \(reference)")
            collectionCell.memberImage.layer.cornerRadius = collectionCell.memberImage.frame.size.width/2
            print("size frame : \(collectionCell.memberImage.frame.size.width / 2)")
            collectionCell.memberImage.layer.masksToBounds = true
            collectionCell.memberImage.clipsToBounds = true
            
            return collectionCell
            
        default:
            
            let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addMemberCell", for: indexPath) as! FamilyDetailCollectionViewCell
            
            // Reference to an image file in Firebase Storage
            
            collectionCell.memberName.text = "Add Member"
            collectionCell.memberImage.image = UIImage(named: "AddMember")
            
            return collectionCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item = self.collectionView(self.memberCollectionOutlet!, numberOfItemsInSection: 0) - 1
        var lastItemIndex = IndexPath(item: item, section: 0)
        let currentCell = collectionView.cellForItem(at: lastItemIndex) as! FamilyDetailCollectionViewCell
        if (indexPath.section) == 0 {
            let row = indexPath.row
            tempFamMemberList = [famMemberList[row].firstName]
            selectedFamMemberId = famMemberList[row].userId
            selectedFamMemberName = famMemberList[row].firstName
            
            //buat back
            selectedFamGroup = MasterFamily
            
            print("selected group : \(selectedFamGroup)")
            print("temp Member List : \(tempFamMemberList)")
            print("Selected fam ID : \(selectedFamMemberId)")
            //        print("selected name : \(famMemberList[row].firstName)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.performSegue(withIdentifier: "commitment", sender: currentCell)
                
            }
        } else {
            let mailCompose = MFMailComposeViewController()
            mailCompose.mailComposeDelegate =  self
            //mailCompose.setToRecipients(["\(famMemberList)"])
            mailCompose.setSubject("Invitation to Who?")
            mailCompose.setMessageBody(" Hello MR/MS who invite you to Join \(MasterFamily) click here to join \(self.MasterFamily) ", isHTML: false)
            if MFMailComposeViewController.canSendMail()
            {
                self.present(mailCompose, animated: true, completion: nil)
            }
            else
            {
                print("!!!!!")
            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//                self.performSegue(withIdentifier: "Family-Invite", sender: currentCell)
//
//            }
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    } 
}



extension FamilyVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("date picked count : \(datePicked.count)")
        
        return availMatchDate.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchDateTableViewCell", for: indexPath) as! MatchDateTableViewCell
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd-MM-yyy"
    
        datePicked = Array(availMatchDate.keys)
        print(datePickedCount)
        datePicked.sort(by: { $0.compare($1 as Date) == ComparisonResult.orderedAscending })
        
        let myString = formatter.string(from: datePicked[indexPath.row] as Date) // string purpose I add here
        // Konversi date ke string
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        cell.dateLabel.text = myStringafd
        cell.passKey = datePicked[indexPath.row]
        cell.passData = availMatchDate
        return cell
    }
}

