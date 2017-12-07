//
//  ColorUtilities.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 09/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import UIKit

private typealias ColorUtilities = UIColor
extension ColorUtilities {
    static let expiredTaskBackground = UIColor.groupTableViewBackground
    static let availableTaskBackground = UIColor.white
    static let taskDone = UIColor(red: 169/255, green: 197/255, blue: 242/255, alpha: 1)
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
        if hexStringTrimmed.count < 8 {
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            self.init(red: CGFloat(Float(r)/255), green: CGFloat(Float(g)/255), blue: CGFloat(Float(b)/255), alpha: 1)
        } else {
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask
            self.init(red: CGFloat(Float(r)/255), green: CGFloat(Float(g)/255), blue: CGFloat(Float(b)/255), alpha: CGFloat(Float(a)/255))
        }
    }

    var toHexString: String {
        var (iRed, iGreen, iBlue, iAlpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        self.getRed(&iRed, green: &iGreen, blue: &iBlue, alpha: &iAlpha)
        let red = Int(iRed * 255)
        let green = Int(iGreen * 255)
        let blue = Int(iBlue * 255)
        let alpha =  Int(iAlpha * 255)
        let hex = NSString(format: "%02X%02X%02X%02X", red, green, blue, alpha) as String
        return hex
    }
}
