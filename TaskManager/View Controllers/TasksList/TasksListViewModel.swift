//
//  TasksListViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 13/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation

protocol TasksListViewModelMDelegate: class, UserInformer {}

class TasksListViewModel {
    //  NOTE: - represents which tasks are shown in which section - completed or pending
    enum TasksStatusSection: Int {
        case pending = 0
        case completed = 1
    }

    private var tasks: [[Task]] = []
    weak var delegate: TasksListViewModelMDelegate?

    init() {
        self.loadData()
    }

    subscript (section: Int, index: Int) -> Task {
        return tasks[section][index]
    }

    func countFor(section: Int) -> Int {
        return tasks[section].count
    }

    var count: Int {
        return tasks.count
    }

    private func remove(section: Int, index: Int) {
        tasks[section].remove(at: index)
    }

    private func addTask(taskToAdd: Task,to section: Int) {
        if tasks[section].isEmpty {
            tasks[section].append(taskToAdd)
        } else {
            for (index, task) in tasks[section].enumerated() {
                if (task.completionDate.compare(taskToAdd.completionDate as Date) == .orderedAscending) {
                    tasks[section].insert(taskToAdd, at: index)
                    break
                } else {
                    if index == tasks[section].count - 1 {
                        tasks[section].append(taskToAdd)
                    }
                }
            }
        }
    }

    func completeTask(at indexPath: IndexPath) {
        if indexPath.section == TasksStatusSection.pending.rawValue {
            let task = self[indexPath.section, indexPath.row]
            let completedTask = Task(taskObject: task, toComplete: true)
            do {
                try RealmManager().updateObject(object: completedTask)
            } catch {
                
            }
            remove(section: indexPath.section, index: indexPath.row)
            addTask(taskToAdd: completedTask,to: TasksStatusSection.completed.rawValue)
        }
    }

    func deleteTask(at indexPath: IndexPath) {
        let taskToDelete = self[indexPath.section, indexPath.row]
        do {
            try RealmManager().deleteobject(object: taskToDelete)
            remove(section: indexPath.section, index: indexPath.row)
        } catch {
            delegate?.informUser(title: R.string.realmErrors.msgUnableToEditTask(taskToDelete.title), message: "")
        }
    }

    func loadData() {
        do {
            let tasks = try RealmManager().getTasks()
            let sortedTasks = tasks.sorted(by: { (leftTask, righTask) -> Bool in
                let descending = (leftTask.completionDate.compare(righTask.completionDate as Date) == .orderedDescending)
                return descending
            })
            var completedTasks: [Task] = []
            var pendingTasks: [Task] = []
            for task in sortedTasks {
                if task.isCompleted {
                    completedTasks.append(task)
                } else {
                    pendingTasks.append(task)
                }
            }

            // NOTE: Pending tasks appear before the completed
            if TasksStatusSection.pending.rawValue == 0 {
                self.tasks = [pendingTasks, completedTasks]
            } else {
                self.tasks = [completedTasks, pendingTasks]
            }
        } catch {
            delegate?.informUser(title: R.string.realmErrors.msgUnableToFetchData("tasks"), message: "")
        }
    }
}
