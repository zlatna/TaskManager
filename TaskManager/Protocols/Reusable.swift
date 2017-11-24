//
//  Reusable.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 24/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
    static var nib: UINib? { return nil}
}
