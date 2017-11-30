//
//  UIAlertController.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 30/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

extension UIAlertController {
    func presentInformation(animated: Bool = false) {
        if let currentViewController = UIApplication.shared.keyWindow?.currentViewController() {
            self.addAction(UIAlertAction(title: R.string.alert.buttonOk() , style: UIAlertActionStyle.cancel, handler: nil))
            currentViewController.present(self, animated: animated, completion: nil)
        }
    }

//    func presentInformationAndSuspendTheApp(animated: Bool = false) {
//        if let currentViewController = UIApplication.shared.keyWindow?.currentViewController() {
//            self.addAction(UIAlertAction(title: R.string.alert.buttonOk() , style: UIAlertActionStyle.cancel, handler: { (_) in
//                UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
//            }))
//            currentViewController.present(self, animated: animated, completion: nil)
//        }
//    }
}
