//
//  UserInformer.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 30/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

protocol UserInformer {
    func informUser(title: String?, message: String?)
}

extension UserInformer where Self: PresentAlertsProtocol {
    func informUser(title: String? = "", message: String? = "") {
        self.showInformationAlert(withTitle: title, message: message, okButtonTitle: R.string.alert.buttonOk())
    }
}
