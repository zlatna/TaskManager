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

    // TODO: have a structure with tasks and categories
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tasks"
        tableView.dataSource = self
        tableView.delegate = self
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "task")
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
                }
            case "openSettings":
                //            if segue.destination is SettingsViewController {
                //
                //            }
                break
            default:
                break
            }
        }
    }
}

extension TasksListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionCount = 1 // TODO: tasks for categories count
        return sectionCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // TODO: categories count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "" //category Name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task")
        // TODO: custom task cell
        
        return cell!
    }
}

extension TasksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: delete task
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
