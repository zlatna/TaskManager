//
//  NotificationsHandler.swift
//  TaskManager
//
//  Created by Zlatna on 8/12/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NotificationsHandler {
    
    static let userDefaultsKeyForNotifications = "Task Manager Notifications"
    static let userDefaultsKeyNotificationsEnabled = "Notifications Enabled"
    class var notificationsLocalyEnabled: Bool {
        get{
            return UserDefaults.standard.bool(forKey: userDefaultsKeyNotificationsEnabled)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: userDefaultsKeyNotificationsEnabled)
        }
    }
    
    class var notificationCenter: UNUserNotificationCenter {
        return UNUserNotificationCenter.current()
    }
    
    class func createNotificationRequest(forTask task: TaskMO) -> UNNotificationRequest {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = task.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy - hh:mm"
        notificationContent.subtitle = dateFormatter.string(from: task.completionDate as Date)
        notificationContent.badge = 1
        
        let timeinterval = task.completionDate.timeIntervalSince(Date())
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: "\(task.objectID)", content: notificationContent, trigger: notificationTrigger)
        return notificationRequest
    }
    
    class func addNotification(forTask task: TaskMO) {
        
        let notificationsEnabled = UserDefaults.standard.bool(forKey: userDefaultsKeyNotificationsEnabled)
        let notificatioRequest = createNotificationRequest(forTask: task)
        
        if notificationsEnabled {
            notificationCenter.add(notificatioRequest, withCompletionHandler: nil)
        } else {
            addRequestInUserDefaults(request: notificatioRequest)
        }
    }
    
    class func removeNotification(forTask task: TaskMO) {
        let notificationsEnabled = UserDefaults.standard.bool(forKey: userDefaultsKeyNotificationsEnabled)
        let taskID = "\(task.objectID)"
        if notificationsEnabled {
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [taskID])
        } else {
            if let currentRequests = getRequestsFromUserDefaults() {
                let filteredRequests =  currentRequests.filter{$0.identifier == taskID}
                storeRequestsInUserDefaults(requests: filteredRequests)
            }
        }
    }
    
    class func suspendNotifications() {
        UserDefaults.standard.set(false, forKey: userDefaultsKeyNotificationsEnabled)
        
        notificationCenter.getPendingNotificationRequests { (notificatioRequests) in
            storeRequestsInUserDefaults(requests: notificatioRequests)
            var requestIDs = [String]()
            for request in notificatioRequests {
                requestIDs.append(request.identifier)
            }
            notificationCenter.removePendingNotificationRequests(withIdentifiers: requestIDs)
        }
    }
    
    class func resumeNotifications() {
        UserDefaults.standard.set(true, forKey: userDefaultsKeyNotificationsEnabled)
        
        if let requests = getRequestsFromUserDefaults() {
            for request in requests {
                notificationCenter.add(request, withCompletionHandler: nil)
            }
            UserDefaults.standard.removeObject(forKey: userDefaultsKeyForNotifications)
        }
    }
    
    
    class func getRequestsFromUserDefaults() -> [UNNotificationRequest]? {
        if let archivedNotifications = UserDefaults.standard.data(forKey: userDefaultsKeyForNotifications),
            let notificationsArray = NSKeyedUnarchiver.unarchiveObject(with: archivedNotifications) as? [UNNotificationRequest] {
            return notificationsArray
        }
        return nil
    }
    
    class func storeRequestsInUserDefaults(requests: [UNNotificationRequest]) {
        let archivedNotifications = NSKeyedArchiver.archivedData(withRootObject: requests)
        UserDefaults.standard.set(archivedNotifications, forKey: userDefaultsKeyForNotifications)
    }
    
    class func addRequestInUserDefaults(request: UNNotificationRequest) {
        var requestsList = getRequestsFromUserDefaults()
        if requestsList != nil {
            requestsList!.append(request)
            storeRequestsInUserDefaults(requests: requestsList!)
        }
    }
    
    class func requestNotificationAuthorization() {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in
        }
    }
}

