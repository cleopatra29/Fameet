//
//  FamilyVC.swift
//  iCal
//
//  Created by Jansen Malvin on 01/02/19.
//  Copyright © 2019 Jansen Malvin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI
import MessageUI
import Kingfisher
import UserNotifications

var selectedFamMemberId :String = ""
var selectedFamMemberName:String = ""
//buat back
var selectedFamGroup: String = ""
var userGlobalDict = [String:UIImage]()

class FamilyVC: UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var tableViewMatchDates: UITableView!
    @IBOutlet weak var memberCollectionOutlet: UICollectionView!
    
    @IBOutlet weak var tableviewConfirmedTime: UITableView!
    
    
    let MasterUser = Auth.auth().currentUser!.uid as String
    
    var famMemberId = [String]()
    var tempFamMemberList : [String] = []
    var famMemberList = [UserCollection]()
    
    var MasterFamily = String()
    var dateModel = DateModel()
    
    var datePicked = [NSDate]()
    var availMatchDate = [NSDate:[String]]()
    
    var confirmedTime = [NSDate]()
    var allConfirmedTime = [NSDate:[String]]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchFamilyCollection(id: MasterFamily)

        memberCollectionOutlet.delegate = self
        memberCollectionOutlet.dataSource = self
        tableViewMatchDates.delegate = self
        tableViewMatchDates.dataSource = self
        
    }
    
    func setupView() {
        familyNameLabel.alpha = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.readUserFamilyGroup()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        famMemberId.removeAll()
        famMemberList.removeAll()
        availMatchDate.removeAll()
        readUserFamilyGroup()
        fetchConfirm()
        
        tableViewMatchDates.reloadData()
        tableviewConfirmedTime.reloadData()
    }
    
    func fetchConfirm(){
        
        Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").getDocuments (completion: { (snapshot, error) in
            if error != nil{
                return print(error)
            } else
            {
                for doc in snapshot!.documents{
                    guard let eventId = doc.documentID as? String,
                        let eventName = doc.data()["event-name"] as? String,
                        let eventLocation = doc.data()["location"] as? String
                        else {return}
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let date = dateFormatter.date(from: eventId)
                    
                    
                    if self.allConfirmedTime[date as! NSDate]?.isEmpty == false {
                        self.allConfirmedTime[date as! NSDate]?.append(eventName)
                        self.allConfirmedTime[date as! NSDate]?.append(eventLocation)
                    } else {
                        self.allConfirmedTime.updateValue([eventName, eventLocation], forKey: date as! NSDate)
                    }
                    print("HAYO LOOOO\(self.allConfirmedTime)")
//                    self.allConfirmedTime.append([eventName])
//                    self.allConfirmedTime.append([eventLocation])
                }
            }
        })
        
    }
    
    func fetchFamilyCollection(id:String){
        Firestore.firestore().collection("family-collection").document(id).getDocument (completion: {(snapshot, error) in
            print("fetch FAM collect id = \(id)")
            guard let fetchFamilyId = snapshot?.documentID,
                let fetchFamilyName = snapshot?.data()!["family-name"] as? String
                else {return}
            self.familyNameLabel.text = "\(fetchFamilyName)'s Family"
        })
    }
    
    func fetchUserCollection(id:String) {
        Firestore.firestore().collection("user-collection").document(id).getDocument (completion: {(snapshot, error) in
            print("id fetch user collect = \(id)")
            if error != nil{
                return print(error!)
            } else {
                guard let fetchUserId = snapshot?.documentID,
                    let fetchUserFirst = snapshot?.data()!["first-name"] as? String,
                    let fetchUserLast = snapshot?.data()!["last-name"] as? String,
                    let fetchEmail = snapshot?.data()!["email"] as? String,
                    let fetchPassword = snapshot?.data()!["password"] as? String,
                    let fetchBirthday = snapshot?.data()!["birthday"] as? String
                    
                    else {return}
                self.famMemberList.append(UserCollection(userId: fetchUserId, firstName: fetchUserFirst, lastName: fetchUserLast, email: fetchEmail, password: fetchPassword, birthday: fetchBirthday))
                
                print("memberLists : \(self.famMemberList)")
                print("famMember count : \(self.famMemberList.count)")
                self.memberCollectionOutlet.reloadData()
            }
        })
    }
    
    func readUserFamilyGroup() {
        Firestore.firestore().collection("family-collection").document(MasterFamily).collection("family-member").getDocuments (completion: { (snapshot, error) in
            if error != nil{
                return print(error!)
            } else {
                for docUserRef in snapshot!.documents {
                    let userRefId = (docUserRef.data()["family-member"] as? DocumentReference)!.documentID as String
                    
                    Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("family-member").document(userRefId).collection("free-time").getDocuments(completion: { (snapshot1, error) in
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
                                                self.availMatchDate[datestring]?.append(userRefId)
                                            } else {
                                                self.availMatchDate.updateValue([userRefId], forKey: datestring)
                                            }
                                            self.tableViewMatchDates.reloadData()
                                            print("userRefID read : \(userRefId)")
                                            
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
                    self.famMemberId.append(userRefId)
                    print("fam member Ids : \(self.famMemberId)")
                }
                for x in self.famMemberId {
                    print("x = \(x)")
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
        } else if let target = segue.destination as? ConfirmedTimeVC {
            target.MasterFamily = MasterFamily as String

            
            
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date / server String
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            guard let isIndex = sender as? Int,
                let idIndex = datePicked[isIndex] as? Date
                else {return}
            let myString = formatter.string(from: idIndex)

             // string purpose I add here
            // convert your string to date
            let yourDate = formatter.date(from: myString)
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "yyyy-MM-dd"
            // again convert your date to string
            let myStringafd = formatter.string(from: yourDate!)
            
            print(myStringafd)
            
            
            print ("ini index : \(isIndex) \n ini value \(idIndex)")
            target.EventId = myStringafd
        }
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
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
        if section == 0{
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
            print("user image reference : \(reference)")
            reference.downloadURL { (url, error) in
                if error != nil{
                    print("error in download url = \(error)")
                }else{
                    let resource = ImageResource(downloadURL: url!, cacheKey: "\(self.famMemberList[indexPath.row].userId).jpg")
                    print("resource download link = \(resource.downloadURL)")
                    print("")
                    print("resource cacheKey = \(resource.cacheKey)")
                    collectionCell.memberImage.kf.setImage(with: resource)
                }
            }
            
            collectionCell.memberName.text = famMemberList[indexPath.row].firstName
//            collectionCell.memberImage.sd_setImage(with: reference, placeholderImage: UIImage(named: "Propic"))
            collectionCell.memberImage.layer.cornerRadius = collectionCell.memberImage.frame.size.width/2
            collectionCell.memberImage.layer.masksToBounds = true
            collectionCell.memberImage.clipsToBounds = true
            print("User list in collection : \(collectionCell.memberName.text)")
            userGlobalDict[famMemberList[indexPath.row].userId] = collectionCell.memberImage.image
            self.tableViewMatchDates.reloadData()
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
        let item = self.collectionView(self.memberCollectionOutlet!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
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
            mailCompose.setSubject("Fameet Group Invitation")
            mailCompose.setMessageBody(" Hi! \(MasterUser) Mr/Ms who invite you to Join \(MasterFamily) click here to join \(self.MasterFamily) ", isHTML: false)
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
        if tableView == tableViewMatchDates{
            print("date picked count : \(datePicked.count)")
            
            return availMatchDate.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: index!) as! MatchDateTableViewCell
        performSegue(withIdentifier: "Family-ConfirmedTime", sender: index?.row)
        tableView.deselectRow(at: index!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewMatchDates {
            let cell = tableView.dequeueReusableCell(withIdentifier: "matchDateTableViewCell", for: indexPath) as! MatchDateTableViewCell
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date / server String
            formatter.dateFormat = "dd-MM-yyy"
            
            datePicked = Array(availMatchDate.keys)
            datePicked.sort(by: { $0.compare($1 as Date) == ComparisonResult.orderedAscending })
            let myString = formatter.string(from: datePicked[indexPath.row] as Date) // string purpose I add here
            // Konversi date ke string
            let yourDate = formatter.date(from: myString)
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "dd-MMM-yyyy"
            // again convert your date to string
            let myStringafd = formatter.string(from: yourDate!)
            
            formatter.dateFormat = "yyyy-MM-dd"
            // again convert your date to string
            //confirmedTime.append(formatter.string(from: yourDate!))
            cell.dateLabel.text = myStringafd
            cell.passKey = datePicked[indexPath.row]
            cell.passData = availMatchDate
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "confirmedTimeTableViewCell", for: indexPath) as! ConfirmedViewCell
            
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date / server String
            formatter.dateFormat = "yyyy-MM-dd"
            
            confirmedTime = Array(allConfirmedTime.keys)
            confirmedTime.sort(by: { $0.compare($1 as Date) == ComparisonResult.orderedAscending })
            let myString = formatter.string(from: confirmedTime[indexPath.row] as Date) // string purpose I add here
            // Konversi date ke string
            let yourDate = formatter.date(from: myString)
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "dd-MMM-yyyy"
            // again convert your date to string
            let myStringafd = formatter.string(from: yourDate!)
            
            // again convert your date to string
            //confirmedTime.append(formatter.string(from: yourDate!))
            print("aaaa :\(confirmedTime) : aaaa")
            
            
            cell.dateConfirmLBL.text = myStringafd
            cell.eventLBL.text = allConfirmedTime[confirmedTime[indexPath.row]]![0]
            cell.locationLBL.text = allConfirmedTime[confirmedTime[indexPath.row]]![1]
            return cell
        }
    }
}
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let index = tableView.indexPathForSelectedRow
//        let currentCell = tableView.cellForRow(at: index!) as! MatchDateTableViewCell
//        performSegue(withIdentifier: "Family-ConfirmedTime", sender: index?.row)
//        tableView.deselectRow(at: index!, animated: true)
    
        
        
        
        
        
//        let alertController = UIAlertController(title: "Create New Group", message: "", preferredStyle: UIAlertController.Style.alert)
//        alertController.addTextField(configurationHandler: { (textField: UITextField!) in
//            textField.placeholder = "Enter Event Name"
//            let OKAction = UIAlertAction(title: "Confirm", style: .default) { (action:UIAlertAction!) in
//                guard let inputEvent = textField.text,
//                    inputEvent != ""
//                    else {
//                        let alertController = UIAlertController(title: "Oops!", message: "Your Event Name is Empty", preferredStyle: .alert)
//
//                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//                            // Code in this block will trigger when OK button tapped.
//                            print("Ok button tapped");
//                        }
//                        alertController.addAction(OKAction)
//                        self.present(alertController, animated: true, completion: nil)
//
//                        print("Text field is empty.")
//                        textField.text = ""
//                        return
//                }
//                // Code in this block will trigger when OK button tapped.
//                let userRef : DocumentReference = Firestore.firestore().document("user-collection/\(self.MasterUser)")
//
//                let dictAdd : [String: Any] = ["event-name" : textField.text]
//
//                let formatter = DateFormatter()
//                // initially set the format based on your datepicker date / server String
//                formatter.dateFormat = "dd-MM-yyy"
//                self.datePicked = Array(self.availMatchDate.keys)
//                let myString = formatter.string(from: self.datePicked[indexPath.row] as Date)
//                // string purpose I add here
//                // Konversi date ke string
//                let yourDate = formatter.date(from: myString)
//                //then again set the date format whhich type of output you need
//                formatter.dateFormat = "yyyy-mm-dd"
//                // again convert your date to string
//                let myStringafd = formatter.string(from: yourDate!)
//
//                Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").document(myStringafd).getDocument { (document, error) in
//                    if let doc = document, document!.exists {
//                        Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").document(myStringafd).setData(dictAdd)
//                        Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").document(myStringafd).collection("joined-member").document(self.MasterUser).setData(["status" : "admin"])
//                        print("data created")
//                    } else {
//                        Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("event-collection").document(myStringafd).collection("joined-member").document(self.MasterUser).setData(["status" : "member"])
//                        print("joined")
//                    }
//                }
//
//
//
//                print("create Ok button tapped")
//
//                let alertDone = UIAlertController(title: "Success", message: "You successfully Confirm", preferredStyle: .alert)
//                let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//
//                }
//                alertDone.addAction(action)
//                self.present(alertDone, animated: true, completion: nil)
//            }
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction!) in
//                print("Cancel button tapped")
//            })
//            alertController.addAction(OKAction)
//            alertController.preferredAction = OKAction
//            alertController.addAction(cancelAction)
//
//        })
    
//    }


//                    print("link download url = \(url!)")
//                    let resource = ImageResource(downloadURL: url!, cacheKey: "\(self.famMemberList[indexPath.row].userId)")
//                    print("resource link = \(resource)")
//                    //check whether an image in the cache
//                    let cache = ImageCache.default
//                    let cached = cache.isCached(forKey: "\(self.famMemberList[indexPath.row].userId)")
//                    let cacheType = cache.imageCachedType(forKey: "\(self.famMemberList[indexPath.row].userId)")
//
//                    //get image from cache
//                    cache.retrieveImage(forKey: "\(self.famMemberList[indexPath.row].userId)") { Result in
//                        switch Result {
//                        case .success(let value) :
//                            print("value cache type = \(value.cacheType)")
//                            print("value cache image = \(value.image)")
//                        case .failure(let error) :
//                            print("error in caching = \(error)")
//                        }
//                    }
//                    collectionCell.memberImage.kf.setImage(with: resource)
