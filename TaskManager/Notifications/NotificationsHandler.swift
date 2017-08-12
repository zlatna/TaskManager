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

// TODO: - globally turn off / on all local notifications - Currently support local turn off/on
//           in case off -  the notifications are not triggered. Instead they are stored in UserDefaults when  turn on localy they are added to the NotificationCenter
// TODO: - support notifications on running app

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
    
    static var notificationsGlobalyEnabled: Bool {
        if let settings = UIApplication.shared.currentUserNotificationSettings?.types {
            return settings.rawValue != 0
        }
        return false
    }
    
    class var notificationCenter: UNUserNotificationCenter {
        return UNUserNotificationCenter.current()
    }
    
    class func createNotificationRequest(forTask task: TaskMO) -> UNNotificationRequest {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = task.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy - hh:mm"
        notificationContent.body = dateFormatter.string(from: task.completionDate as Date)
        notificationContent.badge = 1
        notificationContent.sound = UNNotificationSound.default()
        
        let timeinterval = task.completionDate.timeIntervalSince(Date())
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: "\(task.objectID)", content: notificationContent, trigger: notificationTrigger)
        return notificationRequest
    }
    
    class func addNotification(forTask task: TaskMO) {
        
        let notificatioRequest = createNotificationRequest(forTask: task)
        
        if notificationsLocalyEnabled {
            notificationCenter.add(notificatioRequest, withCompletionHandler: nil)
        } else {
            addRequestInUserDefaults(request: notificatioRequest)
        }
    }
    
    class func removeNotification(forTask task: TaskMO) {
        let taskID = "\(task.objectID)"
        if notificationsLocalyEnabled {
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [taskID])
        } else {
            if let currentRequests = getRequestsFromUserDefaults() {
                let filteredRequests =  currentRequests.filter{$0.identifier == taskID}
                storeRequestsInUserDefaults(requests: filteredRequests)
            }
        }
    }
    
    class func suspendNotifications() {
        notificationsLocalyEnabled = false
        
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
        notificationsLocalyEnabled = true
        
        if let requests = getRequestsFromUserDefaults() {
            for request in requests {
                notificationCenter.add(request, withCompletionHandler: nil)
            }
            UserDefaults.standard.removeObject(forKey: userDefaultsKeyForNotifications)
        }
    }
    
    private class func getRequestsFromUserDefaults() -> [UNNotificationRequest]? {
        if let archivedNotifications = UserDefaults.standard.data(forKey: userDefaultsKeyForNotifications),
            let notificationsArray = NSKeyedUnarchiver.unarchiveObject(with: archivedNotifications) as? [UNNotificationRequest] {
            return notificationsArray
        }
        return nil
    }
    
    private class func storeRequestsInUserDefaults(requests: [UNNotificationRequest]) {
        let archivedNotifications = NSKeyedArchiver.archivedData(withRootObject: requests)
        UserDefaults.standard.set(archivedNotifications, forKey: userDefaultsKeyForNotifications)
    }
    
    private class func addRequestInUserDefaults(request: UNNotificationRequest) {
        var requestsList = getRequestsFromUserDefaults()
        if requestsList != nil {
            requestsList!.append(request)
            storeRequestsInUserDefaults(requests: requestsList!)
        }
    }
    
    class func requestNotificationAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
    }
}
