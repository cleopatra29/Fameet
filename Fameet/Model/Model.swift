//
//  Model.swift
//  iCal
//
//  Created by Jansen Malvin on 30/01/19.
//  Copyright © 2019 Jansen Malvin. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

protocol DocSerialization {
    init?(dictionary : [String : Any])
}

struct UserCollection {
    var userId : String
    var firstName : String
    var lastName : String
    var email : String
    var password : String
    var birthday : String
//    var familyGroup : FamilyGroup?
    
    var dict : [String : Any] {
        return [
            "documentId" : userId,
            "first-name" : firstName,
            "last-name" : lastName,
            "email" : email,
            "password" : password,
            "birthday" : birthday
            //"family-group" : familyGroup!
        ]
    }
}



struct FamilyGroup {
    var familyMemberId : String
    var familyGroupName : FamilyCollection?
    
    var dict : [String : Any] {
        return [
            "documentId" : familyMemberId,
            "family-group-name" : familyGroupName!
            
        ]
    }
}

struct FamilyCollection {
    var familyId : String
    var familyName : String
    //var familyMember : FamilyMember?
    
    var dict : [String : Any] {
        return [
            "documentId" : familyId,
            "family-name" : familyName
            //"family-member" : familyMember!
        ]
    }
}

struct FamilyMember {
    var familyMemberId : String
    var familyMemberRef : UserCollection?
    
    var dict : [String : Any] {
        return [
            "documentId" : familyMemberId,
            "member-reference" : familyMemberRef!
        ]
    }
}

extension NSDate {
    convenience
    init (dateString: String){
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "dd-MM-yyyy"
        dateStringFormatter.locale = NSLocale.current
        let freeDate = dateStringFormatter.date(from: dateString)
        self.init(timeInterval: 25200, since: freeDate!)
        print("freeDate : \(freeDate)")
        print("from dateString : \(dateString)")
    }
}
