//
//  ManageCategoriesViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 11/12/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation

class ManageCategoriesViewModel {
    enum CategoriesSections: Int {
        case customCategpries = 0
        case defaultCategories = 1

        static var count: Int {
            return 2
        }
    }

    fileprivate var customCategories: [TaskCategory] = []
    fileprivate var defaultCategories: [TaskCategory] = []

    init?() {
        loadData()
    }

    func loadData() {
        let categories: [TaskCategory] = RealmManager().getCategories()
        customCategories = []
        defaultCategories = []
        for category in categories {
            if category.isCustom {
                customCategories.append(category)
            } else {
                defaultCategories.append(category)
            }
        }
    }

    func countForSection(section: Int) -> Int {
        switch section {
        case ManageCategoriesViewModel.CategoriesSections.customCategpries.rawValue:
            return  customCategories.count
        case ManageCategoriesViewModel.CategoriesSections.defaultCategories.rawValue:
            return defaultCategories.count
        default:
            return 0
        }
    }

    func categoryAtIndexPath(indexPath: IndexPath) -> TaskCategory? {
        switch indexPath.section {
        case ManageCategoriesViewModel.CategoriesSections.customCategpries.rawValue:
            return customCategories[indexPath.row]
        case ManageCategoriesViewModel.CategoriesSections.defaultCategories.rawValue:
            return defaultCategories[indexPath.row]
        default:
            return nil
        }
    }

}
