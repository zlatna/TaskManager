//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 13/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
protocol TaskVMDelegate: class, UserInformer {}

class TaskViewModel {
    weak var delegate: TaskVMDelegate?
    private var task: TaskMO?
    private(set) var mode: EditMode
    init?(task: TaskMO?, to mode: EditMode) throws {
        guard (task != nil && mode == .update) || (task == nil && mode == .create) else {
            throw InitializationErrors.wrongParameters(message: "task: \(String(describing: task)), mode: \(mode)")
        }
        self.task = task
        self.mode = mode
    }

    var completionDate: Date {
        if let task = self.task {
            return task.completionDate as Date
        } else {
            return Date()
        }
    }

    var title: String {
        return self.task?.title ?? ""
    }

    var category: CategoryMO? {
        return task?.category
    }

    func saveTask(with title: String, completionDate: Date, category: CategoryMO) {
        if let taskToSave = task {
            do {
                try CoreDataHandler.editTask(taskToSave, title: title, completionDate: completionDate, category: category)
                NotificationsHandler.removeNotification(forTask: taskToSave)
                NotificationsHandler.addNotification(forTask: taskToSave)
            } catch let error {
                assertionFailure(error.localizedDescription)
            }
        } else {
            do {
                let newTask = try CoreDataHandler.addNewTask(withTitle: title, completionDate: completionDate, category: category)
                NotificationsHandler.addNotification(forTask: newTask)
            } catch let error {
                assertionFailure(error.localizedDescription)
            }
        }
    }

    func deleteTask() {
        do {
            if let currentTask = task {
                try CoreDataHandler.deleteTask(currentTask)
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }
}
