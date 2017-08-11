//
//  AddTaskViewController.swift
//  TaskManager
//
//  Created by Zlatna on 8/10/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit
import UserNotifications
// TODO: Fetch categories
// TODO: Create/Update task
// TODO: onSave - create notification

class TaskViewController: UITableViewController {
    
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    enum Mode{
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
        
        switch mode! {
        case .update:
            navigationItem.title = "task Title"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(TaskViewController.onSaveButton))
            
        case .create:
            navigationItem.title = "task Title"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(TaskViewController.onAddTaskButton))
            
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(TaskViewController.onCloseButton))
        
        categories = CoreDataHandler.fetchAllCategories()
        
        if task != nil {
            titleTextView.text = task!.title
            datePicker.setDate(task!.completionDate as Date, animated: false)
            categoryPicker.selectRow(categories.index(of: task!.category) ?? 0, inComponent: 0, animated: false)
        }
    }
    
    func onSaveButton() {
        self.navigationController?.popViewController(animated: true)
        print("save task")
    }
    
    func onCloseButton() {
        self.navigationController?.popViewController(animated: true)
        print("cancel task update")
    }
    
    func onAddTaskButton() {
        let title = titleTextView.text
        let date = datePicker.date
        
        if title == nil || title == "" {
            showAllert(title: "Enter task title.", text: "")
        } else {
            if Date().compare(date) == .orderedDescending || Date().compare(date) == .orderedSame {
                showAllert(title: "Enter correct date", text: "")
            } else {
                CoreDataHandler.addNewTask(withTitle: title!, completionDate: datePicker.date, category: categories[categoryPicker.selectedRow(inComponent: 0)])
                self.navigationController?.popViewController(animated: true)
                print("Add new task")
            }
        }
    }
    
    private func createNotification() {
        
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO: set the task's category
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = categories[row].name
        label.textAlignment = .center
        label.backgroundColor = categories[row].uiColor
        return label
    }
}

extension UIViewController {
    
    func showAllert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
