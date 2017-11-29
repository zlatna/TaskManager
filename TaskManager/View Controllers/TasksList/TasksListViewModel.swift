//
//  TasksListViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 13/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation

class TasksListViewModel {
    //    represents which tasks are shown in which section - completed or pending
    enum TasksStatusSection: Int {
        case pending = 0
        case completed = 1
    }

    private var tasks: [[TaskMO]] = []

    init() {
        self.loadData()
    }

    subscript (section: Int, index: Int) -> TaskMO {
        return tasks[section][index]
    }

    func countFor(section: Int) -> Int {
        return tasks[section].count
    }

    var count: Int {
        return tasks.count
    }

    func remove(section: Int, index: Int) {
        tasks[section].remove(at: index)
    }

    func addTask(taskToAdd: TaskMO,to section: Int) {
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
            let taskToComplete = self[indexPath.section, indexPath.row]
            do {
                try CoreDataHandler.editTask(taskToComplete, isCompleted: true)
                remove(section: indexPath.section, index: indexPath.row)
                addTask(taskToAdd: taskToComplete,to: TasksStatusSection.completed.rawValue)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }

    func deleteTask(at indexPath: IndexPath) {
        let taskToDelete = self[indexPath.section, indexPath.row]
        do {
            try CoreDataHandler.deleteTask(taskToDelete)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        remove(section: indexPath.section, index: indexPath.row)
    }

    func loadData() {
        do {
            let tasksMO = try CoreDataHandler.fetchAllTasks()
            let sortedTasks = tasksMO.sorted(by: { (leftTask, righTask) -> Bool in
                let descending = (leftTask.completionDate.compare(righTask.completionDate as Date) == .orderedDescending)
                return descending
            })
            var completedTasks: [TaskMO] = []
            var pendingTasks: [TaskMO] = []
            for task in sortedTasks {
                if task.isCompleted {
                    completedTasks.append(task)
                } else {
                    pendingTasks.append(task)
                }
            }
            // Pending tasks appear before the completed
            if TasksStatusSection.pending.rawValue == 0 {
                self.tasks = [pendingTasks, completedTasks]
            } else {
                self.tasks = [completedTasks, pendingTasks]
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }

    }
}
