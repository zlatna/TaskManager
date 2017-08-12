//
//  SettingsViewContoller.swift
//  TaskManager
//
//  Created by Zlatna on 8/10/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var notificationSwitchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        notificationSwitch.isOn = NotificationsHandler.notificationsLocalyEnabled
    }
    
    @IBAction func onNotificationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            notificationSwitchLabel.text = "Turn off notifications"
            NotificationsHandler.resumeNotifications()
            NotificationsHandler.notificationsLocalyEnabled = true
        } else {
            notificationSwitchLabel.text = "Turn on notifications"
            NotificationsHandler.suspendNotifications()
            NotificationsHandler.notificationsLocalyEnabled = false
        }
    }
}


