//
//  TaskCell.swift
//  TaskManager
//
//  Created by Zlatna on 8/11/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    var task: TaskMO?
    @IBOutlet weak var categoryColorView: UIView!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var completionDateLabel: UILabel!
    @IBOutlet weak var customSeparator: UIView!
    
}
