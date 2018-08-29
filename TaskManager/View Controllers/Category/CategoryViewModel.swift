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
    private var category: TaskCategory?
    var mode: EditMode = .create
    
    init?(category: TaskCategory?, mode: EditMode) throws {
        guard (category != nil && mode == .update) || (category == nil && mode == .create) else {
            throw InitializationErrors.wrongParameters(message: R.string.initializationErrors.msgUnableToInitializeCategory("\(mode)"))
        }
        if let category = category {
            self.category = category
            self.mode = mode
        }
    }
    
    var color: UIColor? {
        return category?.uiColor
    }
    var name: String {
        return category?.name ?? ""
    }
    
    var isRelatedToTask: Bool {
        return category?.tasks.isEmpty == false
    }
    
    func createCategoryWith(name: String, andColor color: UIColor) {
        let category = TaskCategory(color: color.toHexString, name: name)
        RealmManager().addObject(object: category)
    }
    
    func updateCategory(name: String, color: UIColor) {
        do {
            if let categoryToUpdate = category,
               categoryToUpdate.name != name || categoryToUpdate.color != color.toHexString {
                let updatedCategory = TaskCategory(id: categoryToUpdate.id,
                                                   color: color.toHexString,
                                                   name: name,
                                                   isCustom: categoryToUpdate.isCustom)
                RealmManager().updateObject(object: updatedCategory)
            }
        }
    }
    
    func deleteCurrentCategory() {
        if let categoryToDelete = category {
            RealmManager().deleteobject(object: categoryToDelete)
            mode = .delete
        }
    }
}
