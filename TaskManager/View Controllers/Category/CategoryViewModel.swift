//
//  CategoryViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 07/12/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryViewModelDelegate: class, UserInformer {}

class CategoryViewModel {
    private var category: TaskCategory?
    var mode: EditMode = .create
    weak var delegate: CategoryViewModelDelegate?
    
    init?(category: TaskCategory?, mode: EditMode, delegate: CategoryViewModelDelegate) throws {
        guard (category != nil && mode == .update) || (category == nil && mode == .create) else {
            throw InitializationErrors.wrongParameters(message: R.string.initializationErrors.msgUnableToInitializeCategory("\(mode)"))
        }
        if let category = category {
            self.category = category
            self.mode = mode
        }
        self.delegate = delegate
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
        do {
            try RealmManager().addObject(object: category)
        } catch {
            delegate?.informUser(title: R.string.realmErrors.msgUnableToAddCategory(category.name), message: "")
        }
    }
    
    func updateCategory(name: String, color: UIColor) {
        if let categoryToUpdate = category,
            categoryToUpdate.name != name || categoryToUpdate.color != color.toHexString {
            let updatedCategory = TaskCategory(id: categoryToUpdate.id,
                                               color: color.toHexString,
                                               name: name,
                                               isCustom: categoryToUpdate.isCustom)
            do {
                try RealmManager().updateObject(object: updatedCategory)
            } catch {
                delegate?.informUser(title: R.string.realmErrors.msgUnableToEditCategory(categoryToUpdate.name), message: "")
            }
        }
    }
    
    func deleteCurrentCategory() {
        if let categoryToDelete = category {
            do {
                try RealmManager().deleteobject(object: categoryToDelete)
                mode = .delete
            } catch {
                delegate?.informUser(title: R.string.realmErrors.msgUnableToDeleteCategory(categoryToDelete.name), message: "")
            }
        }
    }
}
