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
    var uiColor: UIColor {
        let color = UIColor(fromHex: self.color)
        return color
    }
    class func createAndStoreCategories() {
        let waslaunchedBefore = UserDefaults.standard.bool(forKey: UserDefaultsIdentifiers.launchedBefore.rawValue)
        if (!waslaunchedBefore) {
            let categories = CategoriesAndColors().dictionary
            for (categoryName, categoryColor) in categories {
                do {
                    try CoreDataHandler.addNewCategory(named: categoryName, color: categoryColor, custom: false)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
            UserDefaults.standard.set(true, forKey: UserDefaultsIdentifiers.launchedBefore.rawValue)
        }
    }
}
