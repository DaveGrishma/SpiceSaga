//
//  UICollectionView+Extentions.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 18/10/23.
//

import UIKit

extension UICollectionView {
    func getCell<T:UICollectionViewCell>(_ type: T.Type,indexPath: IndexPath) -> T? {
        let cellId: String = String(describing: type.self)
        if let cell = self.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? T {
            return cell
        }
        return nil
    }
}

