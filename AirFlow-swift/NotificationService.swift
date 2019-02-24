//
//  NotificationService.swift
//  AirFlow-swift
//
//  Created by bestK1ng on 24/02/2019.
//

import Foundation
import UserNotifications

class NotificationService {

    static let standart = NotificationService()
    
    func checkNotificationRequest() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (_, _) in
            // TODO: Handle notification auth
        }
    }
    
    func showNotification(title: String, body: String) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.categoryIdentifier = "message"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
        
        let notificationRequest = UNNotificationRequest(identifier: "local.message", content: notificationContent, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
    }
}
