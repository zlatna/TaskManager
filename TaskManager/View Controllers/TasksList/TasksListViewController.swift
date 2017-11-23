//
//  TasksListViewController.swift
//  TaskManager
//
//  Created by Zlatna on 8/10/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

class TasksListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate var taskListVM: TasksListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tasks"
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if taskListVM != nil {
            loadData()
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
                    destinationViewController.taskVM = TaskViewModel(task: nil, to: .create)
                }
            case .openExistingTask:
                if let destinationViewController = segue.destination as? TaskViewController {
                    if let selectedIndexPath = tableView.indexPathForSelectedRow {
                        let task = taskListVM[selectedIndexPath.section, selectedIndexPath.row]
                        destinationViewController.taskVM = TaskViewModel(task: task, to: .update)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.taskCell.rawValue ) as? TaskCell {
            let task = taskListVM[indexPath.section, indexPath.row]
            cell.setup(task: task)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if TasksListViewModel.TasksStatusSection.completed.rawValue == section {
            return "Completed Tasks"
        }
        if TasksListViewModel.TasksStatusSection.pending.rawValue == section {
            return "Pending Tasks"
        }
        return nil
    }
}

// MARK: - Table View Delegate
extension TableConfig: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskListVM[indexPath.section, indexPath.row]
            taskListVM.remove(section: indexPath.section, index: indexPath.row)//(at: indexPath.row)
            CoreDataHandler.sharedInstance.deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //if TasksListViewModel.TasksStatusSection.completed.rawValue == indexPath.section {
            let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { (_, _, _) in
                self.taskListVM.deleteTask(at: indexPath)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            return UISwipeActionsConfiguration(actions:[delete])
        //}
        //return UISwipeActionsConfiguration(actions:[]) //If the return value is nil the cell is deletable
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if TasksListViewModel.TasksStatusSection.pending.rawValue == indexPath.section {
            let done = UIContextualAction(style: .normal, title: "Done", handler: { (_, _, _) in
                DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
                    self.taskListVM.completeTask(at: indexPath)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
            done.backgroundColor = UIColor(displayP3Red: 169/255, green: 197/255, blue: 242/255, alpha: 1)
            return UISwipeActionsConfiguration(actions:[done])
        }
        return nil
    }

    @available(iOS 10.0, *)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if TasksListViewModel.TasksStatusSection.completed.rawValue == indexPath.section {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            self.taskListVM.deleteTask(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
            return [delete]
        }

        if TasksListViewModel.TasksStatusSection.pending.rawValue == indexPath.section {
            let done = UITableViewRowAction(style: .normal, title: "Done") { (_, indexPath ) in
                DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
                    self.taskListVM.completeTask(at: indexPath)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            done.backgroundColor = UIColor(displayP3Red: 169/255, green: 197/255, blue: 242/255, alpha: 1)
            return [done]
        }
        return []
    }
}
