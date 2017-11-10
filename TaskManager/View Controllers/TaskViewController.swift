//
//  AddTaskViewController.swift
//  TaskManager
//
//  Created by Zlatna on 8/10/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit
import UserNotifications

class TaskViewController: UITableViewController, PresentAlertsProtocol {
    
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var deleteTaskButton: UIButton!
    
    enum Mode {
        case update
        case create
    }
    
    var mode: Mode?
    var categories: [CategoryMO] = []
    var task: TaskMO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        titleTextView.autocorrectionType = .no
        switch mode! {
        case .update:
            navigationItem.title = "task Title"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(TaskViewController.onSaveButton))
            
        case .create:
            navigationItem.title = "task Title"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(TaskViewController.onAddTaskButton))
            deleteTaskButton.isHidden = true
            
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(TaskViewController.onCloseButton))
        
        categories = CoreDataHandler.fetchAllCategories()
        
        if task != nil {
            titleTextView.text = task!.title
            datePicker.setDate(task!.completionDate as Date, animated: false)
            categoryPicker.selectRow(categories.index(of: task!.category) ?? 0, inComponent: 0, animated: false)
        }
    }
    
    @objc func onSaveButton() {
        if let task = self.task {
            let title = titleTextView.text
            let date = datePicker.date
            
            if title == nil || title == "" {
                self.showInformationAlert(withTitle: "Enter task title.", message: "")
            } else {
                if Date().compare(date) == .orderedDescending || Date().compare(date) == .orderedSame {
                    self.showInformationAlert(withTitle: "Enter correct date", message: "")
                } else {
                    let category = categories[categoryPicker.selectedRow(inComponent: 0)]
                    if task.title != title || task.completionDate.compare(date) != .orderedSame || task.category.objectID == category.objectID {
                        CoreDataHandler.editTask(task, title: title, completionDate: date, category: categories[categoryPicker.selectedRow(inComponent: 0)])
                        NotificationsHandler.removeNotification(forTask: task)
                        NotificationsHandler.addNotification(forTask: task)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func onCloseButton() {
        self.navigationController?.popViewController(animated: true)
        print("cancel task update")
    }
    func onAddTaskButton() {
        let title = titleTextView.text
        let date = datePicker.date
        if title == nil || title == "" {
            self.showInformationAlert(withTitle: "Enter task title.", message: "")
        } else {
            if Date().compare(date) == .orderedDescending || Date().compare(date) == .orderedSame {
                self.showInformationAlert(withTitle: "Enter correct date", message: "")
            } else {
                let category = categories[categoryPicker.selectedRow(inComponent: 0)]
                if let task = CoreDataHandler.addNewTask(withTitle: title!, completionDate: date, category: category) {                    
                    NotificationsHandler.addNotification(forTask: task)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func deleteTask(_ sender: UIButton) {
        if let task = self.task {
            CoreDataHandler.deleteTask(task)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension TaskViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
}

extension TaskViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = categories[row].name
        label.textAlignment = .center
        label.backgroundColor = categories[row].uiColor
        return label
    }
}
