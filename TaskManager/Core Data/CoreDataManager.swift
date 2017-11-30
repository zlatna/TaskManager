//
//  CoreDataManager.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 23/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let sharedInstance = CoreDataManager()
    private init() {}

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskManager")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                throw CoreDataErrors.saveContex(message: error.localizedDescription)
            }
        }
    }

    // MARK: - Core Data Fetching support
    func fetchData<T: NSManagedObject>(with fetchRequest: NSFetchRequest<T>) throws -> [T]? {
        var resultList: [T]? = nil
        do {
            resultList = try viewContext.fetch(fetchRequest)
        } catch let error {
            throw error
        }
        return resultList
    }
}
