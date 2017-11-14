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
                        let task = taskListVM[selectedIndexPath.row]
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

private typealias TableConfig = TasksListViewController
extension TableConfig: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsNumber = taskListVM.count
        return rowsNumber
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.taskCell.rawValue ) as? TaskCell {
            let task = taskListVM[indexPath.row]
            cell.setup(task: task)
            return cell
        }
        return UITableViewCell()
    }
}

extension TableConfig: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskListVM[indexPath.row]
            taskListVM.remove(at: indexPath.row)
            CoreDataHandler.sharedInstance.deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
