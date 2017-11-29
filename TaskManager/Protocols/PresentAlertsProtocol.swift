//
//  PresentAlertsProtocol.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 10/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//
import UIKit

protocol PresentAlertsProtocol {
    func showInformationAlert(withTitle title: String, message: String, okButtonTitle: String)
}

extension PresentAlertsProtocol where Self: UIViewController {
    func showInformationAlert(withTitle title: String, message: String, okButtonTitle: String = R.string.alert.ok()) {
        self.present({ () in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okButtonTitle, style: .cancel, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            }))
            return alert
        }(), animated: true, completion: nil)
    }
}
