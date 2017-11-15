//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 13/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation

class TaskViewModel {
    enum Mode {
        case update
        case create
    }

    private var task: TaskMO?
    private(set) var mode: Mode
    init(task: TaskMO?, to mode: Mode) {
        assert((task != nil && mode == .update) || (task == nil && mode == .create), "incorrect task data")
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
            CoreDataHandler.sharedInstance.editTask(taskToSave, title: title, completionDate: completionDate, category: category)
            NotificationsHandler.removeNotification(forTask: taskToSave)
            NotificationsHandler.addNotification(forTask: taskToSave)
        } else {
            let newTask = CoreDataHandler.sharedInstance.addNewTask(withTitle: title, completionDate: completionDate, category: category)
            assert(newTask != nil, "Task have not been created")
            NotificationsHandler.addNotification(forTask: newTask!)
        }
    }

    func deleteTask() {
        assert(task != nil, "Task have not been deleted")
        CoreDataHandler.sharedInstance.deleteTask(task!)
    }
}
