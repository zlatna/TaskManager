//
//  CoreDataHandler.swift
//  TaskManager
//
//  Created by Zlatna on 8/11/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandler {
}

// MARK: - TaskMO altering and extracting
typealias CoreDataTaskHandler = CoreDataHandler
extension CoreDataTaskHandler {
    // MARK: - altering
    class func deleteTask(_ task: TaskMO) throws {
        let context = CoreDataManager.sharedInstance.viewContext
        context.delete(task)
        do {
            try context.save()
        } catch let error {
            throw CoreDataErrors.deleteTask(message: error.localizedDescription, taskTitle: task.title)
        }
    }

    //TODO: to not return
    class func addNewTask(withTitle title: String, completionDate: Date, category: CategoryMO) throws -> TaskMO {
        let context = CoreDataManager.sharedInstance.viewContext
        let task = TaskMO(context: context)

        task.setValuesForKeys([ #keyPath(TaskMO.title): title, #keyPath(TaskMO.completionDate) : completionDate, #keyPath(TaskMO.category) : category])
        task.title = title
        task.completionDate = completionDate as NSDate
        task.category = category
        task.isCompleted = false
        do {
            try context.save()
            return task
        } catch let error {
            throw CoreDataErrors.addTask(message: error.localizedDescription, taskTitle: task.title)
        }
    }

    class func editTask(_ task: TaskMO, title: String? = nil, completionDate: Date? = nil, category: CategoryMO? = nil, isCompleted: Bool? = nil) throws {
        let context = CoreDataManager.sharedInstance.viewContext
        if let taskTitle = title {
            task.setValue(taskTitle, forKey: #keyPath(TaskMO.title))
        }

        if let taskcompletionDate = completionDate as NSDate? {
            task.setValue(taskcompletionDate, forKey: #keyPath(TaskMO.completionDate))
        }

        if let taskcategory = category {
            task.setValue(taskcategory, forKey: #keyPath(TaskMO.category))
        }

        if let taskIsCompleted = isCompleted {
            task.setValue(taskIsCompleted, forKey: #keyPath(TaskMO.isCompleted))
        }

        do {
            try context.save()
        } catch let error {
            throw CoreDataErrors.editTask(message: error.localizedDescription, taskTitle: task.title)
        }
    }

    // MARK: - extracting
    class func fetchAllTasks() throws -> [TaskMO] {
        var tasksList: [TaskMO] = []
        let context = CoreDataManager.sharedInstance.viewContext
        let fetchRequest: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()

        do {
            tasksList = try context.fetch(fetchRequest)
        } catch let error {
            throw CoreDataErrors.fetchTasks(message: error.localizedDescription)
        }
        return tasksList
    }
}

// MARK: - CategoryMO altering and extracting
typealias CoreDataCategoryHandler = CoreDataHandler
extension CoreDataCategoryHandler {
    // MARK: - altering
    class func editCategory(category: CategoryMO, name: String?, color: UIColor?) throws {
        if let newName = name {
            category.setValue(newName, forKey: #keyPath(CategoryMO.name))
        }

        if let newColor = color {
            category.setValue(newColor.toHexString, forKey: #keyPath(CategoryMO.color))
        }

        do {
            let context = CoreDataManager.sharedInstance.viewContext
            try context.save()
        } catch {
            throw CoreDataErrors.editCategory(message: R.string.coreDataErrors.msgUnableToEditCategory(category.name))
        }
    }

    class func deleteCategory(_ category: CategoryMO) throws {
        let context = CoreDataManager.sharedInstance.viewContext
        context.delete(category)
        do {
            try context.save()
        } catch {
            throw CoreDataErrors.deleteCategory(message: R.string.coreDataErrors.msgUnableToDeleteCategory(category.name))
        }
    }

    class func addNewCategory(named name: String, color: String, custom: Bool = true) throws {
        let context = CoreDataManager.sharedInstance.viewContext

        let category = CategoryMO(context: context)
        category.setValuesForKeys([#keyPath(CategoryMO.name) : name, #keyPath(CategoryMO.color) : color, #keyPath(CategoryMO.custom) : custom])
        do {
            try context.save()
        } catch let error {
            throw CoreDataErrors.addCategory(message: error.localizedDescription, categoryName: category.name)
        }
    }

    class func addNewCategories(_ categories: [CategoryMO]) throws {
        let context = CoreDataManager.sharedInstance.viewContext
        for category in categories {
            context.insert(category)
        }
        do {
            try context.save()
        } catch let error {
            throw CoreDataErrors.addCategories(message: error.localizedDescription)
        }
    }

    // MARK: - extracting
    class func fetchAllCategories() throws -> [CategoryMO] {
        let fetchRequest: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
        do {
            guard let categoriesList = try CoreDataManager.sharedInstance.fetchData(with: fetchRequest) else {
                throw CoreDataErrors.fetchCategories(message: R.string.coreDataErrors.msgUnableToFetchData("Categories"))
            }
            return categoriesList
        } catch let error {
            throw CoreDataErrors.fetchCategories(message: error.localizedDescription)
        }
    }
}
