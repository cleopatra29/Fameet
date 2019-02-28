//
//  LocalPushManager.swift
//  Fameet
//
//  Created by Christian Limansyah on 28/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import Foundation
import UserNotifications

class LocalPushManager: NSObject{
    static var shared = LocalPushManager()
    let center = UNUserNotificationCenter.current()
    
    func sendLocalPush(in time: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Notification works", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Strings", arguments: nil)
        
        //trigger push notif
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error == nil{
                print("Schedule push succeed")
            }
        }
    }
}
