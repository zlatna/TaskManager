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

    static let sharedInstance = CoreDataHandler()
    private var managedContext: NSManagedObjectContext?

    private init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
    }
    // MARK: Task
    func deleteTask(_ task: TaskMO) {

        if let context = managedContext {
            context.delete(task)

            do {
                try context.save()
            } catch let error as NSError {
                debugPrint("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    //TODO: to not return
    func addNewTask(withTitle title: String, completionDate: Date, category: CategoryMO) -> TaskMO? {
        if let context = managedContext {

            let task = TaskMO(context: context)
            task.setValuesForKeys(["title" : title, "completionDate" : completionDate, "category" : category])
            task.title = title
            task.completionDate = completionDate as NSDate
            task.category = category

            do {
                try context.save()
                return task
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        return nil
    }

    func editTask(_ task: TaskMO, title: String?, completionDate: Date?, category: CategoryMO?) {
        if let context = managedContext {
            if let taskTitle = title {
                task.setValue(taskTitle, forKey: "title")
            }

            if let taskcompletionDate = completionDate as NSDate? {
                task.setValue(taskcompletionDate, forKey: "completionDate")
            }

            if let taskcategory = category {
                task.setValue(taskcategory, forKey: "category")
            }

            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    func fetchAllTasks() -> [TaskMO] {
        var tasksList: [TaskMO] = []
         if let context = managedContext {
            let fetchRequest: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()

            do {
                tasksList = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        return tasksList
    }

    // MARK: Category
    func addNewCategory(named name: String, color: String) {
        if let context = managedContext {

            let category = CategoryMO(context: context)
            category.setValuesForKeys(["name" : name, "color" : color])

            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    func addNewCategories(_ categories: [CategoryMO]) {
        if let context = managedContext {
            for category in categories {
                context.insert(category)
            }
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    func fetchAllCategories() -> [CategoryMO] {
        var categoriesList: [CategoryMO] = []
        if let context = managedContext {
            let fetchRequest: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
            do {
                categoriesList = try context.fetch(fetchRequest)
            } catch let error as NSError {
                debugPrint("Could not fetch. \(error)")
            }
        }
        return categoriesList
    }
}
