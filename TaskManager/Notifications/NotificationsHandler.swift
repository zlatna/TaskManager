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
//       - support notifications on running app

// MARK: - Notifications handler
class NotificationsHandler {
    static let userDefaultsKeyForNotifications = "Task Manager Notifications"
    static let userDefaultsKeyNotificationsEnabled = "Notifications Enabled"
}

// MARK: - Notifications Setup
private typealias NotificationsSetup = NotificationsHandler
extension NotificationsSetup {
    class var notificationsLocalyEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: userDefaultsKeyNotificationsEnabled)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultsKeyNotificationsEnabled)
        }
    }

    /// Executes closures depending on the current notification setings. The closures are executed asynchronous.
    ///
    /// - Parameters:
    ///   - enabled: Closure to execute if the notification settings are enabled
    ///   - disabled: Closure to execute if the notification settings are disabled
    class func executeForNotification(enabled: @escaping () -> Void, disabled: @escaping () -> Void) {
        self.notificationCenter.getNotificationSettings { (settings) in
            if settings.notificationCenterSetting == UNNotificationSetting.enabled {
                enabled()
            } else {
                disabled()
            }
        }
    }

    class var notificationCenter: UNUserNotificationCenter {
        return UNUserNotificationCenter.current()
    }

    class func requestNotificationAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
            if granted {
                notificationsLocalyEnabled = true
            }
        }
    }
}

// MARK: - Notifications Management
private typealias NotificationsManager = NotificationsHandler
extension NotificationsManager {
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
                let filteredRequests =  currentRequests.filter {$0.identifier == taskID}
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
}

// MARK: - Notifications Helpers
private typealias NotificationsHelper = NotificationsHandler
extension NotificationsHelper {
    class func createNotificationRequest(forTask task: TaskMO) -> UNNotificationRequest {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = task.title
        notificationContent.body = CustomDateFormatter.defaultFormatedDate(date: task.completionDate as Date)
        notificationContent.badge = 1
        notificationContent.sound = UNNotificationSound.default()

        let timeinterval = task.completionDate.timeIntervalSince(Date())
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: "\(task.objectID)", content: notificationContent, trigger: notificationTrigger)
        return notificationRequest
    }
}

private typealias NotificationSuspendingHelper = NotificationsHandler
extension NotificationSuspendingHelper {
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
}
