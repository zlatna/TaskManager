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

    var tasks: [String : [TaskMO]] = [:]
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tasks"
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        tableView.reloadData()
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
        let tasksMO = CoreDataHandler.fetchAllTasks()
        tasks = [:]
        for task in tasksMO {
            let category = task.category.name
            if tasks[category] != nil {
                tasks[category]!.append(task)
            } else {
                tasks[category] = [task]
            }
        }
        categories = Array(tasks.keys)
    }
}

extension TasksListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let inSectionCount = tasks[categories[section]]?.count
        return inSectionCount ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let categoriesCount = categories.count
        return categoriesCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = categories[section]
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskCell
        
        let task = tasks[categories[indexPath.section]]![indexPath.row]
        
        cell.categoryColorView.layer.cornerRadius = cell.categoryColorView.bounds.width / 2
        cell.categoryColorView.backgroundColor = task.category.uiColor
        cell.taskTitleLabel.text = task.title
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd,yyyy - hh:mm"
        cell.completionDateLabel.text = dateformatter.string(from: task.completionDate as Date)
        if task.completionDate.compare(Date()) == .orderedAscending {
            cell.backgroundColor = UIColor.lightGray
        }
        cell.task = task
        
        return cell
    }
}

extension TasksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[categories[indexPath.section]]![indexPath.row]
            if (tasks[categories[indexPath.section]]?.count)! > 1 {
                tasks[categories[indexPath.section]]?.remove(at: indexPath.row)
            } else {
                tasks.removeValue(forKey: categories[indexPath.section])
            }
            CoreDataHandler.deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
