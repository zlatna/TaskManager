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
    var taskVM: TaskViewModel!
    var categoriesVM: TaskCategoriesViewModel = TaskCategoriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        titleTextView.autocorrectionType = .no
        switch taskVM.mode {
        case .update:
            navigationItem.title = "task Title"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(TaskViewController.onSaveButton))
        case .create:
            navigationItem.title = "task Title"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(TaskViewController.onAddTaskButton))
            deleteTaskButton.isHidden = true
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(TaskViewController.onCloseButton))
        titleTextView.text = taskVM.title
        datePicker.setDate(taskVM.completionDate, animated: false)
        categoryPicker.selectRow(categoriesVM.index(of: taskVM.category), inComponent: 0, animated: false)
    }
    
    @objc func onSaveButton() {
        if taskVM.mode == TaskViewModel.Mode.update &&
            (taskVM.title != titleTextView.text || taskVM.completionDate.compare(datePicker.date) != .orderedSame || taskVM.category?.objectID != categoriesVM[categoryPicker.selectedRow(inComponent: 0)].objectID) {
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
    
    @IBAction func deleteTask(_ sender: UIButton) {
        taskVM.deleteTask()
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkFieldsAndSaveTask() {
        var title: String
        let date = datePicker.date
        if titleTextView.text == nil || titleTextView.text == "" {
            self.showInformationAlert(withTitle: "Enter task title.", message: "")
        } else {
            title = titleTextView.text!
            
            if Date().compare(date) == .orderedDescending || Date().compare(date) == .orderedSame {
                self.showInformationAlert(withTitle: "Enter correct date", message: "")
            } else {
                let category = categoriesVM[categoryPicker.selectedRow(inComponent: 0)]
                taskVM.saveTask(with: title, completionDate: date, category: category)
            }
        }
    }
}

private typealias CategoryPickerConfig = TaskViewController
extension TaskViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesVM.count
    }
}

extension TaskViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = categoriesVM[row].name
        label.textAlignment = .center
        label.backgroundColor = categoriesVM[row].uiColor
        return label
    }
}
