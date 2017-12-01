//
//  TasksListViewController.swift
//  TaskManager
//
//  Created by Zlatna on 8/10/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

class TasksListViewController: UIViewController, PresentAlertsProtocol, TasksListVMDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate var taskListVM: TasksListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = R.string.tasksList.labelTasksListTitle()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if taskListVM != nil {
            loadData()
            taskListVM.delegate = self
        } else {
            taskListVM = TasksListViewModel()
            self.activityIndicator.stopAnimating()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = SegueIdentifiers(rawValue: segue.identifier!) {
            switch segueIdentifier {
            case .addNewTask:
                if let destinationViewController = segue.destination as? TaskViewController {
                    do {
                        destinationViewController.taskVM = try TaskViewModel(task: nil, to: .create)
                    } catch let error {
                        assertionFailure(error.localizedDescription)
                    }
                }
            case .openExistingTask:
                if let destinationViewController = segue.destination as? TaskViewController {
                    if let selectedIndexPath = tableView.indexPathForSelectedRow {
                        let task = taskListVM[selectedIndexPath.section, selectedIndexPath.row]
                        do {
                        destinationViewController.taskVM = try TaskViewModel(task: task, to: .update)
                        } catch let error {
                            assertionFailure(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }

    private func loadData() {
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            self.taskListVM.loadData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - Table View Data Source
private typealias TableConfig = TasksListViewController
extension TableConfig: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsNumber = taskListVM.countFor(section: section)
        return rowsNumber
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return taskListVM.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as TaskCell
        let task = taskListVM[indexPath.section, indexPath.row]
        cell.setup(task: task)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if TasksListViewModel.TasksStatusSection.completed.rawValue == section {
            return R.string.tasksList.sectionTitleCompletedTasks()
        }
        if TasksListViewModel.TasksStatusSection.pending.rawValue == section {
            return R.string.tasksList.sectionTitlePendingTasks()
        }
        return nil
    }
}

// MARK: - Table View Delegate
extension TableConfig: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let delete = UIContextualAction(style: .destructive, title: R.string.tasksList.actionDelete(), handler: { (_, _, _) in
                self.taskListVM.deleteTask(at: indexPath)
                self.tableView.reloadData()
            })
            return UISwipeActionsConfiguration(actions:[delete])
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if TasksListViewModel.TasksStatusSection.pending.rawValue == indexPath.section {
            let done = UIContextualAction(style: .normal, title: R.string.tasksList.actionDone(), handler: { (_, _, _) in
                DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
                    self.taskListVM.completeTask(at: indexPath)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
            done.backgroundColor = UIColor.taskDone
            return UISwipeActionsConfiguration(actions:[done])
        }
        return nil
    }

    @available(iOS 10.0, *)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if TasksListViewModel.TasksStatusSection.completed.rawValue == indexPath.section {
        let delete = UITableViewRowAction(style: .destructive, title: R.string.tasksList.actionDelete()) { (_, indexPath) in
            self.taskListVM.deleteTask(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
            return [delete]
        }

        if TasksListViewModel.TasksStatusSection.pending.rawValue == indexPath.section {
            let done = UITableViewRowAction(style: .normal, title: R.string.tasksList.actionDone()) { (_, indexPath ) in
                DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
                    self.taskListVM.completeTask(at: indexPath)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            done.backgroundColor = UIColor.taskDone
            return [done]
        }
        return []
    }
}
