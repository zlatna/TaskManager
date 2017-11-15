//
//  AddTaskViewController.swift
//  TaskManager
//
//  Created by Zlatna on 8/10/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit
import UserNotifications
//import TextFieldEffects

class TaskViewController: UITableViewController, PresentAlertsProtocol {
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var deleteTaskButton: UIButton!
    @IBOutlet weak var taskDueDateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    fileprivate var taskDueDate: Date = Date()
    fileprivate var taskCategory: CategoryMO? {
        didSet {
            categoryTextField.text = taskCategory?.name
            //            categoryTextField.borderActiveColor = taskCategory?.uiColor
            //            categoryTextField.borderInactiveColor = taskCategory?.uiColor
        }
    }
    
    var taskVM: TaskViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTextField.inputView = categoryPickerView
        taskDueDateTextField.inputView = dueDatePicker
        titleTextView.autocorrectionType = .no
        
        switch taskVM.mode {
        case .update:
            navigationItem.title = "Update task"
            taskDueDateTextField.text = CustomDateFormatter.defaultFormatedDate(date: taskVM.completionDate)
            taskDueDate = taskVM.completionDate
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(TaskViewController.onSaveButton))
        case .create:
            navigationItem.title = "Crate new task"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(TaskViewController.onAddTaskButton))
            deleteTaskButton.isHidden = true
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(TaskViewController.onCloseButton))
        titleTextView.text = taskVM.title
    }
    
    // MARK: - Actions
    @objc func onSaveButton() {
        if taskVM.mode == TaskViewModel.Mode.update &&
            (taskVM.title != titleTextView.text ||
                taskVM.completionDate.compare(taskDueDate) != .orderedSame ||
                taskVM.category?.objectID != taskCategory?.objectID) {
            checkFieldsAndSaveTask()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func onCloseButton() {
        self.navigationController?.popViewController(animated: true)
        print("cancel task update")
    }
    
    @objc func onAddTaskButton() {
        checkFieldsAndSaveTask()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didEndTitleEdit(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    @IBAction func deleteTask(_ sender: UIButton) {
        taskVM.deleteTask()
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkFieldsAndSaveTask() {
        var title: String
        if titleTextView.text == nil || titleTextView.text == "" {
            self.showInformationAlert(withTitle: "Enter task title.", message: "")
        } else {
            title = titleTextView.text!
            
            if Date().compare(taskDueDate) == .orderedDescending || Date().compare(taskDueDate) == .orderedSame {
                self.showInformationAlert(withTitle: "Enter correct date", message: "")
            } else {
                guard let category = taskCategory else {
                    return
                }
                taskVM.saveTask(with: title, completionDate: taskDueDate, category: category)
            }
        }
    }
    @IBAction func taskDueDateTouchUpInside(_ sender: UITextField) {
        sender.inputView = UIDatePicker()
    }
}

typealias CategoryPickerConfig = TaskViewController
extension CategoryPickerConfig {
    fileprivate var categoryPickerView: TaskCategoryPicker? {
        if let pickerView = Bundle.main.loadNibNamed("TaskCategoryPicker", owner: TaskCategoryPicker.self, options: nil)?.first as? TaskCategoryPicker {
            let width = self.view.bounds.width
            let height = self.view.bounds.height * 0.3
            let viewFrame = CGRect(origin: pickerView.frame.origin, size: CGSize(width: width, height: height))
            pickerView.frame = viewFrame
            return pickerView
        }
        return nil
    }

}

private typealias TaskDueDatePickerConfig = TaskViewController
extension TaskDueDatePickerConfig {
    fileprivate var dueDatePicker: UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(pickerDueDateValueDidChanged) , for: .valueChanged)
        return datePicker
    }
    
    @objc func pickerDueDateValueDidChanged(sender: UIDatePicker) {
        taskDueDate = sender.date
        let dateString = CustomDateFormatter.defaultFormatedDate(date: taskDueDate)
        taskDueDateTextField.text = dateString
    }
}
