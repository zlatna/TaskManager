//
//  AddTaskViewController.swift
//  TaskManager
//
//  Created by Zlatna on 8/10/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit
import UserNotifications
import TextFieldEffects

class TaskViewController: UITableViewController, PresentAlertsProtocol {
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var deleteTaskButton: UIButton!
    @IBOutlet weak var taskDueDateTextField: UITextField!
    @IBOutlet weak var categoryTextField: HoshiTextField!
    var taskVM: TaskViewModel!

    fileprivate var dueDatePicker: UIDatePicker?
    fileprivate var taskDueDate: Date? {
        didSet {
            if let dueDate = taskDueDate {
                let dateString = CustomDateFormatter.defaultFormatedDate(date: dueDate)
                taskDueDateTextField.text = dateString
            }
        }
    }

    fileprivate var categoryPickerView: TaskCategoryPicker?
    fileprivate var taskCategory: CategoryMO? {
        didSet {
            categoryTextField.text = taskCategory?.name
            //categoryTextField.borderInactiveColor = taskCategory?.uiColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPickerView = createPickerView()
        categoryTextField.inputView = categoryPickerView
        dueDatePicker = createDatePickerView()
        taskDueDateTextField.inputView = dueDatePicker
        titleTextView.autocorrectionType = .no

        switch taskVM.mode {
        case .update:
            navigationItem.title = "Update task"
            taskDueDate = taskVM.completionDate
            titleTextView.text = taskVM.title
            taskCategory = taskVM.category

        case .create:
            navigationItem.title = "Crate new task"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(TaskViewController.onAddTaskButton))
            deleteTaskButton.isHidden = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(TaskViewController.onCloseButton))
        }
    }

    // MARK: - Actions
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            onSaveButton()
        }
    }

    @objc func onSaveButton() {
        if taskVM.mode == TaskViewModel.Mode.update &&
            (taskVM.title != titleTextView.text ||
                taskVM.completionDate.compare(taskDueDate ?? Date()) != .orderedSame ||
                taskVM.category?.objectID != taskCategory?.objectID) {
            checkFieldsAndSaveTask()
        }
    }

    @objc func onCloseButton() {
        self.navigationController?.popViewController(animated: true)
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
        guard let title = titleTextView.text,
            title != "" else {
                self.showInformationAlert(withTitle: "Enter task title.", message: "")
                return
        }
        guard let dueDate = taskDueDate,
            Date().compare(dueDate) == .orderedAscending else {
                self.showInformationAlert(withTitle: "Enter correct date", message: "")
                return
        }
        guard let category = taskCategory else {
            self.showInformationAlert(withTitle: "Select category", message: "")
            return
        }
        taskVM.saveTask(with: title, completionDate: dueDate, category: category)
    }

    @IBAction func taskDueDateTouchUpInside(_ sender: UITextField) {
        sender.inputView = UIDatePicker()
    }
}

// MARK: - Category Picker
typealias CategoryPickerConfig = TaskViewController
extension CategoryPickerConfig: CategoryPickerDelegate {
    fileprivate func createPickerView() -> TaskCategoryPicker? {
        if let pickerView = Bundle.main.loadNibNamed(TaskCategoryPicker.nibName, owner: TaskCategoryPicker.self, options: nil)?.first as? TaskCategoryPicker {
            let width = self.view.bounds.width
            let height = self.view.bounds.height * 0.3
            let viewFrame = CGRect(origin: pickerView.frame.origin, size: CGSize(width: width, height: height))
            pickerView.frame = viewFrame
            pickerView.delegate = self
            pickerView.selectedItem = taskVM.category
            return pickerView
        }
        return nil
    }

    func didSelectItem(_ item: CategoryMO) {
        taskCategory = item
    }
}

// MARK: - Due Date Picker
private typealias TaskDueDatePickerConfig = TaskViewController
extension TaskDueDatePickerConfig {
    fileprivate func createDatePickerView() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date().addingTimeInterval(60)
        datePicker.date = taskVM.completionDate
        datePicker.addTarget(self, action: #selector(pickerDueDateValueDidChanged) , for: .valueChanged)
        return datePicker
    }

    @objc func pickerDueDateValueDidChanged(sender: UIDatePicker) {
        taskDueDate = sender.date
    }
}
