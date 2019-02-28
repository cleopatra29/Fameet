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
        content.body = NSString.localizedUserNotificationString(forKey: String, arguments: <#T##[Any]?#>)
    }
}
