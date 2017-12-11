//
//  CategoryViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 07/12/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import UIKit

class CategoryViewModel {
    private var category: CategoryMO?
    var mode: EditMode = .create

    init?(category: CategoryMO?, mode: EditMode) throws {
        guard (category != nil && mode == .update) || (category == nil && mode == .create) else {
            throw InitializationErrors.wrongParameters(message: R.string.initializationErrors.msgUnableToInitializeCategory("\(mode)"))
        }
        self.category = category
        self.mode = mode
    }

    var color: UIColor? {
        return category?.uiColor
    }
    var name: String? {
        return category?.name
    }

    func createCategoryWith(name: String, andColor color: UIColor) {
        do {
            try CoreDataHandler.addNewCategory(named: name, color: color.toHexString)
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }

    func updateCategory(name: String?, color: UIColor?) {
        do {
            if let categoryToUpdate = category,
                categoryToUpdate.name != name || categoryToUpdate.color != color?.toHexString {
            try CoreDataHandler.editCategory(category: categoryToUpdate, name: name, color: color)
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }

    func deleteCurrentCategory() {
        do {
            if let categoryToDelete = category {
                try CoreDataHandler.deleteCategory(categoryToDelete)
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }
}
