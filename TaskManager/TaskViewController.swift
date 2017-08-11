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
    
    // TODO: Get categories with name and colour for the picker view
    
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
        self.navigationController?.popViewController(animated: true)
        print("Add new task")
    }
    
    private func createNotification() {
        
    }
}

extension TaskViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1//categories.count
    }
}

extension TaskViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO: set the task's category
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = ""// TODO: Category name
        label.textAlignment = .center
        label.backgroundColor = UIColor.red // TODO: Category Colour
        return label
    }
}
