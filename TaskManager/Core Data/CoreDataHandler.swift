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
        task.setValuesForKeys(["title" : title, "completionDate" : completionDate, "category" : category])
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
            task.setValue(taskTitle, forKey: "title")
        }

        if let taskcompletionDate = completionDate as NSDate? {
            task.setValue(taskcompletionDate, forKey: "completionDate")
        }

        if let taskcategory = category {
            task.setValue(taskcategory, forKey: "category")
        }

        if let taskIsCompleted = isCompleted {
            task.setValue(taskIsCompleted, forKey: "isCompleted")
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
    class func addNewCategory(named name: String, color: String) throws {
        let context = CoreDataManager.sharedInstance.viewContext

        let category = CategoryMO(context: context)
        category.setValuesForKeys(["name" : name, "color" : color])
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
                throw CoreDataErrors.fetchCategories(message: "Cannot Fetch categories")
            }
            return categoriesList
        } catch let error {
            throw CoreDataErrors.fetchCategories(message: error.localizedDescription)
        }
    }
}
