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

class TaskViewController: UITableViewController, PresentAlertsProtocol, TaskVMDelegate {
    fileprivate struct TaskConfig {
        static var minimumDateToSet: Date {
            return Date().addingTimeInterval(60)
        }
    }
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var deleteTaskButton: UIButton!
    @IBOutlet weak var taskDueDateTextField: UITextField!
    @IBOutlet weak var categoryTextField: HoshiTextField!
    var taskVM: TaskViewModel!

    fileprivate var isDeleting = false
    fileprivate var dueDatePickerView: UIDatePicker?
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
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDueDate()
        setupCategory()
        titleTextView.autocorrectionType = .no
        setupModePreview()
    }

    // MARK: - Actions
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            switch taskVM.mode {
            case .update:
                onSave()
            case .create:
                break
            }
        }
    }

    func onSave() {
        if !isDeleting && taskVM.mode == TaskViewModel.Mode.update &&
            (taskVM.title != titleTextView.text ||
                taskVM.completionDate.compare(taskDueDate ?? Date()) != .orderedSame ||
                taskVM.category?.objectID != taskCategory?.objectID) {
            checkFieldsAndSaveTask()
        }
    }

    func onCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func onAddTask() {
        checkFieldsAndSaveTask()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func didEndTitleEdit(_ sender: UITextField) {
        self.resignFirstResponder()
    }

    @IBAction func deleteTask(_ sender: UIButton) {
        taskVM.deleteTask() //?????
        self.isDeleting = true
        self.navigationController?.popViewController(animated: true)
    }

    func checkFieldsAndSaveTask() {
        guard let title = titleTextView.text,
            title != "" else {
                self.showInformationAlert(withTitle: R.string.taskView.msgEnterTaskTitle(), message: "")
                return
        }
        guard let dueDate = taskDueDate,
            Date().compare(dueDate) == .orderedAscending else {
                self.showInformationAlert(withTitle: R.string.taskView.msgEnterCorrectDateForTask(), message: "")
                return
        }
        guard let category = taskCategory else {
            self.showInformationAlert(withTitle: R.string.taskView.msgSelectCategoryForTask(), message: "")
            return
        }
        taskVM.saveTask(with: title, completionDate: dueDate, category: category)
    }
}

// MARK: - Initial Fiels Setup
extension TaskViewController {
    func setupCategory() {
        categoryPickerView = createPickerView()
        categoryTextField.inputView = categoryPickerView
        categoryTextField.delegate = self
    }

    func setupDueDate() {
        dueDatePickerView = createDatePickerView()
        taskDueDateTextField.inputView = dueDatePickerView
        taskDueDateTextField.delegate = self
    }

    func setupModePreview() {
        switch taskVM.mode {
        case .update:
            navigationItem.title = R.string.taskView.labelUpdateTaskTitle()
            taskDueDate = taskVM.completionDate
            titleTextView.text = taskVM.title
            taskCategory = taskVM.category

        case .create:
            navigationItem.title = R.string.taskView.labelCreateTaskTitle()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.string.taskView.buttonAddTask(), style: .done, target: self, action: #selector(TaskViewController.onAddTask))
            deleteTaskButton.isHidden = true
        }
    }
}

// MARK: - Category Picker
private typealias CategoryPickerConfig = TaskViewController
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
        datePicker.minimumDate = TaskConfig.minimumDateToSet
        datePicker.date = taskVM.completionDate
        datePicker.addTarget(self, action: #selector(pickerDueDateValueDidChanged) , for: .valueChanged)
        return datePicker
    }
    @objc func pickerDueDateValueDidChanged(sender: UIDatePicker) {
        taskDueDate = sender.date
    }
}

// MARK: - TextFieldDelegate
private typealias TextFieldDisabledForUserEdition = TaskViewController
extension TextFieldDisabledForUserEdition: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.categoryTextField  || textField == self.taskDueDateTextField {
            return false
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.taskDueDateTextField {
            switch taskVM.mode {
            case .create:
                taskDueDate = TaskConfig.minimumDateToSet
            default:
                break
            }
        }
    }
}
