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
    fileprivate var tasks: [TaskMO] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tasks"
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = SegueIdentifiers(rawValue: segue.identifier!) {
            switch segueIdentifier {
            case .addNewTask:
                if let destinationViewController = segue.destination as? TaskViewController {
                    destinationViewController.mode = .create
                }
            case .openExistingTask:
                if let destinationViewController = segue.destination as? TaskViewController {
                    destinationViewController.mode = .update
                    if let selectedIndexPath = tableView.indexPathForSelectedRow {
                        let task = tasks[selectedIndexPath.row]
                       destinationViewController.task = task
                    }
                }
            }
        }
    }
    private func loadData() {
        //activityIndicator.startAnimating()
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            let tasksMO = CoreDataHandler.sharedInstance.fetchAllTasks()
            let sortedTasks = tasksMO.sorted(by: { (leftTask, righTask) -> Bool in
                let descending = (leftTask.completionDate.compare(righTask.completionDate as Date) == .orderedDescending)
                return descending
            })
            DispatchQueue.main.async {
                self.tasks = sortedTasks
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

private typealias TableConfig = TasksListViewController
extension TableConfig: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsNumber = tasks.count
        return rowsNumber
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.taskCell.rawValue ) as? TaskCell {
            let task = tasks[indexPath.row]
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
            let task = tasks[indexPath.row]
            tasks.remove(at: indexPath.row)
            CoreDataHandler.sharedInstance.deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
