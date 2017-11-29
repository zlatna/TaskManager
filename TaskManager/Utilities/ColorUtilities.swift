//
//  ColorUtilities.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 09/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import UIKit

typealias ColorUtilities = UIColor
extension ColorUtilities {
    static let expiredTaskBackgroundColor = UIColor.groupTableViewBackground
    static let availableTaskBackgroundColor = UIColor.white
    static let taskDoneColor = UIColor(displayP3Red: 169/255, green: 197/255, blue: 242/255, alpha: 1)
}

extension UIColor {
    convenience init(fromHex hexString: String) {
        //convert the string color, which represents hex number, to UIColor, https://gist.github.com/yannickl/16f0ed38f0698d9a8ae7
        let hexStringTrimmed = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexStringTrimmed)
        if (hexStringTrimmed.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        self.init(red: CGFloat(Float(r)/255), green: CGFloat(Float(g)/255), blue: CGFloat(Float(b)/255), alpha: 1)
    }
}
