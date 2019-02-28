//
//  DataFetcher.swift
//  FinalChallengeVessel
//
//  Created by Jansen Malvin on 07/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import Foundation
import Firebase

class DataFetcher {
    let MasterUser = Auth.auth().currentUser?.uid as! String
    var MasterFamily = String()
    let dateModel = DateModel()
    
    var famMemberId = [String]()
    var famMemberList = [UserCollection]()
    var groupArr = [FamilyCollection]()
    var datePicked = [NSDate]()
    var availMatchDate = [NSDate:[String]]()
    
    func readUserFamilyGroup(MasterUser : String) -> [FamilyCollection] {
        var userFamId = [String]()
        var familyfetch = [FamilyCollection]()
        Firestore.firestore().collection("user-collection").document(MasterUser).collection("family-group").getDocuments (completion: { (snapshot, error) in
            if error != nil{
                return print(error)
            } else {
                for docFamRef in snapshot!.documents {
                    let famRefId = (docFamRef.data()["family-group-name"] as! DocumentReference).documentID as! String
                    print(famRefId)
                    userFamId.append(famRefId)
                }
                for familyId in userFamId {
                    Firestore.firestore().collection("family-collection").document(familyId).getDocument (completion: {(snapshot, error) in
                        if error != nil{
                            return print(error)
                        } else {
                            guard let fetchFamId = snapshot?.documentID as? String,
                                let fetchFamName = snapshot?.data()!["family-name"] as? String
                                else {return}
                            
                            familyfetch.append(FamilyCollection(familyId: fetchFamId, familyName: fetchFamName))
                            //self.homeTableViewOutlet.reloadData()
                        }
                    })
                }
            }
        })
        return familyfetch
    }
    
//    func fetchFamilyCollection(familyId : String){
//        Firestore.firestore().collection("family-collection").document(familyId).getDocument (completion: {(snapshot, error) in
//            if error != nil{
//                return print(error)
//            } else {
//                guard let fetchFamId = snapshot?.documentID as? String,
//                    let fetchFamName = snapshot?.data()!["family-name"] as? String
//                    else {return}
//
//                familyfetch.append(FamilyCollection(familyId: fetchFamId, familyName: fetchFamName))
//                //self.homeTableViewOutlet.reloadData()
//            }
//        })
//    }
    
    
    
    func readUserFamilyGroup1(MasterFamily : String) {
        Firestore.firestore().collection("family-collection").document(MasterFamily).collection("family-member").getDocuments (completion: { (snapshot, error) in
            if error != nil{
                return print(error)
            } else {
                for docUserRef in snapshot!.documents {
                    let userRefId = (docUserRef.data()["member-reference"] as! DocumentReference).documentID as! String
                    //                    print(userRefId)
                    Firestore.firestore().collection("family-collection").document(self.MasterFamily).collection("family-member").document(userRefId).collection("free-time").getDocuments(completion: { (snapshot1, error) in
                        
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
                                        self.datePicked.append(datestring)
                                        if self.availMatchDate[datestring]?.isEmpty == false {
                                            self.availMatchDate[datestring]?.append(userRefId)
                                        } else {
                                            self.availMatchDate.updateValue([userRefId], forKey: datestring)
                                        }
                                        print(userRefId)
                                        print(self.datePicked)
                                        print(self.availMatchDate)
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
                        self.datePicked.sort(by: { $0.compare($1 as Date) == ComparisonResult.orderedAscending })
                    })
                    self.famMemberId.append(userRefId)
                }
                for x in self.famMemberId {
                    //self.fetchFamilyCollection(familyId : x)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    //                    print(self.famMemberList)
                    print(self.availMatchDate)
                })
            }
        })
    }
}
