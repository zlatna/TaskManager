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

    fileprivate var customCategories: [CategoryMO] = []
    fileprivate var defaultCategories: [CategoryMO] = []

    init?() {
        loadData()
    }

    func loadData() {
        var categories: [CategoryMO] = []
        do {
            categories = try CoreDataHandler.fetchAllCategories()
            customCategories = []
            defaultCategories = []
            for category in categories {
                if category.custom {
                    customCategories.append(category)
                } else {
                    defaultCategories.append(category)
                }
            }
        } catch {
            assertionFailure(error.localizedDescription)
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

    func categoryAtIndexPath(indexPath: IndexPath) -> CategoryMO? {
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
