//
//  CategoryMO.swift
//  TaskManager
//
//  Created by Zlatna on 8/11/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//
import Foundation
import UIKit

extension CategoryMO {
    
    //convert the string color, which represents hex number, to UIColor, https://gist.github.com/yannickl/16f0ed38f0698d9a8ae7
    var uiColor: UIColor {
        let hexString = self.color.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        return UIColor(red: CGFloat(Float(r)/255), green: CGFloat(Float(g)/255), blue: CGFloat(Float(b)/255), alpha: 1)
    }
    
    
    class func createAndStoreCategories() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if (!launchedBefore) {
            let colors = ["#C6DA02", "#79A700", "#F68B2C", "#E2B400", "#F5522D", "#FF6E83"]
            var i = 1
            for color in colors {
                CoreDataHandler.addNewCategory(named: "category \(i)", color: color)
                i+=1
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
}
