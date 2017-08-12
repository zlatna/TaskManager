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
    
    var tasks: [TaskMO] = []
    
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
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case "addNewTask":
                if let destinationViewController = segue.destination as? TaskViewController {
                    destinationViewController.mode = .create
                }
            case "openExistingTask":
                if let destinationViewController = segue.destination as? TaskViewController {
                    destinationViewController.mode = .update
                    if let cell = sender as? TaskCell {
                        destinationViewController.task = cell.task
                    }
                }
            default:
                break
            }
        }
    }
    
    private func loadData() {
        //activityIndicator.startAnimating()
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            let tasksMO = CoreDataHandler.fetchAllTasks()
            let sortedTasks = tasksMO.sorted(by: { (leftTask, righTask) -> Bool in
                let descending = (leftTask.completionDate.compare(Date()) == .orderedDescending)
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

extension TasksListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsNumber = tasks.count
        return rowsNumber
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskCell
        
        let task = tasks[indexPath.row]
        cell.task = task
        
        cell.categoryColorView.layer.cornerRadius = cell.categoryColorView.bounds.width / 2
        let categoryColor = task.category.uiColor
        cell.categoryColorView.backgroundColor = categoryColor
        cell.customSeparator.backgroundColor = categoryColor
        cell.taskTitleLabel.text = task.title
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd,yyyy - hh:mm"
        cell.completionDateLabel.text = dateformatter.string(from: task.completionDate as Date)
        let timeinterval = task.completionDate.timeIntervalSince(Date())
        if timeinterval < 1 {
            cell.backgroundColor = UIColor.groupTableViewBackground
        }else{
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
}

extension TasksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            tasks.remove(at: indexPath.row)
            CoreDataHandler.deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
