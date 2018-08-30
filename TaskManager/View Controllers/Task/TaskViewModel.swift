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
    private var task: Task?
    private(set) var mode: EditMode

    init?(task: Task?, to mode: EditMode) {
        guard (task != nil && mode == .update) || (task == nil && mode == .create) else {
            assertionFailure("task: \(String(describing: task)), mode: \(mode)")
            return nil
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

    var category: TaskCategory? {
        return task?.category
    }

    func saveTask(with title: String, completionDate: Date, category: TaskCategory) {
        if let taskToSave = task {
            let updatedTask = Task.init(id: taskToSave.id,
                                        completionDate: completionDate,
                                        title: title,
                                        isCompleted: false,
                                        category: category)
            do {
                try RealmManager().updateObject(object: updatedTask)
            } catch {
                delegate?.informUser(title: R.string.realmErrors.msgUnableToEditTask(taskToSave.title), message: "")
            }
            NotificationsHandler.removeNotification(forTask: taskToSave)
            NotificationsHandler.addNotification(forTask: updatedTask)
        } else {
            do {
                let newTask = Task(completionDate: completionDate, title: title, isCompleted: false, category: category)
                try RealmManager().addObject(object: newTask)
                NotificationsHandler.addNotification(forTask: newTask)
            } catch {
                delegate?.informUser(title: R.string.realmErrors.msgUnableToAddTask(title), message: "")
            }
        }
    }

    func deleteTask() {
        if let currentTask = task {
            do {
                try RealmManager().deleteobject(object: currentTask)
                mode = .delete
            } catch {
                delegate?.informUser(title: R.string.realmErrors.msgUnableToDeleteTask(currentTask.title), message: "")
            }
        } else {
            assertionFailure("Deleting non existing task")
        }
    }
}
