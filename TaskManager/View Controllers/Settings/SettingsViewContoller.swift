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
        navigationItem.title = R.string.settings.labelSettingsTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationsHandler.executeForNotification(enabled: {
                                                        DispatchQueue.main.sync {
                                                            self.notificationSwitch.isOn = NotificationsHandler.notificationsLocalyEnabled
                                                        }},
                                                    disabled:  {
                                                        DispatchQueue.main.sync {
                                                            self.notificationSwitch.isEnabled = false
                                                            NotificationsHandler.suspendNotifications()
                                                            self.notificationSwitch.isOn = false
                                                        }
        })

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    @IBAction func onNotificationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            notificationSwitchLabel.text = R.string.settings.labelTurnOffNotifications()
            NotificationsHandler.resumeNotifications()
            NotificationsHandler.notificationsLocalyEnabled = true
        } else {
            notificationSwitchLabel.text = R.string.settings.labelTurnOnNotifications()
            NotificationsHandler.suspendNotifications()
            NotificationsHandler.notificationsLocalyEnabled = false
        }
    }
}
