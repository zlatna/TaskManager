//
//  ManageCategoriesViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 11/12/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
protocol ManageCategoriesViewModelDelegate: class, UserInformer { }

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
    weak var delegate: ManageCategoriesViewModelDelegate?

    init?() {
        loadData()
    }

    func loadData() {
        do {
            let categories: [TaskCategory] = try RealmManager().getCategories()
            customCategories = []
            defaultCategories = []
            for category in categories {
                if category.isCustom {
                    customCategories.append(category)
                } else {
                    defaultCategories.append(category)
                }
            }
        } catch {
            delegate?.informUser(title: R.string.realmErrors.msgUnableToFetchData("categories"), message: "")
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
