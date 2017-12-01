//
//  UITableView.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 24/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//
import UIKit

extension UITableView {
    func registerReusable<T: UITableViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: Reusable {
        let dequedCell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T
        assert(dequedCell != nil, R.string.viewErrors.msgUnableToDequeView(String(describing: T.self)))
        return dequedCell!
    }

    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: Reusable {
        let dequedView = self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T
        assert(dequedView != nil, R.string.viewErrors.msgUnableToDequeView(String(describing: T.self)))
        return dequedView!
    }
}
