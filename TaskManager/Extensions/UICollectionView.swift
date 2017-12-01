//
//  UICollectionView.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 24/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerReusable<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }

    /// Deques a cell conforming to Reusable
    /// - Parameter indexPath: The index path specifying the location of the cell.
    /// The data source receives this information when it is asked for the cell and should just pass it along.
    /// This method uses the index path to perform additional configuration based on the cell’s position in the collection view.
    /// - Returns: Returns a reusable cell object conforming to Reusable
    func dequeReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: Reusable {
        let dequedCell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
        assert(dequedCell != nil, String(describing: T.self))
        return dequedCell!
    }

    func registerReusableSuplementaryView<T: Reusable>(elementKind: String, _: T.Type) {
        if let nib = T.nib {
            self.register(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(elementKind: String, indexPath: IndexPath) throws -> T where T: Reusable {
        let dequedView = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
        assert(dequedView != nil, R.string.viewErrors.msgUnableToDequeView(String(describing: T.self)))
        return dequedView!
    }
}
