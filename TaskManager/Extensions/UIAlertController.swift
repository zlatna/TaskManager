//
//  UIAlertController.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 30/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

extension UIAlertController {
    func presentInformation(title: String? = "", message: String? = "", okHandler: ((UIAlertAction) -> Void)? = nil, animated: Bool = false) {
        if let currentViewController = UIApplication.shared.keyWindow?.currentViewController() {
            self.title = title
            self.message = message
            self.addAction(UIAlertAction(title: R.string.alert.buttonOk() , style: UIAlertActionStyle.cancel, handler: okHandler))
            currentViewController.present(self, animated: animated, completion: nil)
        }
    }
}
