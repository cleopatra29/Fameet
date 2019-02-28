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


//extension UserCollection : DocSerialization {
//    init?(dictionary : [String :Any]) {
//        guard let userIdEx = dictionary["documentId"] as? String,
//            let firstNameEx = dictionary["first-name"] as? String,
//            let lastNameEx = dictionary["last-name"] as? String,
//            let emailEx = dictionary["email"] as? String,
//            let passwordEx = dictionary["password"] as? String,
//            let birthdayEx = dictionary["birthday"] as? String
//            //let familyGroupEx = dictionary["family-group"] as? FamilyGroup
//            else {return nil}
//        self.init(userId : userIdEx, firstName : firstNameEx, lastName : lastNameEx, email : emailEx, password : passwordEx, birthday : birthdayEx)
//    }
//}




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

//extension FamilyGroup : DocSerialization {
//    init?(dictionary: [String : Any]) {
//        guard let familyMemberIdEx = dictionary["documentId"] as? String,
//        let familyGroupNameEx = dictionary["family-group-name"] as? FamilyCollection
//        else{ return nil }
//        self.init(familyMemberId : familyMemberIdEx, familyGroupName : familyGroupNameEx)
//    }
//}


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

//extension FamilyCollection : DocSerialization {
//    init?(dictionary : [String : Any]) {
//        guard let familyIdEx = dictionary["documentId"] as? String,
//            let familyNameEx = dictionary["family-name"] as? String
//            //let familyMember = dictionary[""] as? FamilyMember
//            else {return nil}
//        self.init(familyId : familyIdEx, familyName : familyNameEx)
//    }
//}




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


//extension FamilyMember : DocSerialization {
//    init?(dictionary: [String : Any]) {
//        guard let familyMemberIdEx = dictionary["documentId"] as? String,
//        let familyMemberRefEx = dictionary["member-reference"] as? UserCollection
//        else { return nil }
//        self.init(familyMemberId: familyMemberIdEx, familyMemberRef: familyMemberRefEx)
//    }
//}


extension NSDate {
    convenience
    init (dateString: String){
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "dd-MM-yyyy"
        dateStringFormatter.locale = NSLocale.current
        let freeDate = dateStringFormatter.date(from: dateString)
        self.init(timeInterval: 0, since: freeDate!)
        print("freeDate : \(freeDate)")
        print("from dateString : \(dateString)")
    }
}
