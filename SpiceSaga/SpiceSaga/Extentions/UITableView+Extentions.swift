//
//  UITableView+Extentions.swift
//  SpiceSaga
//
//  Created by psagc on 06/11/23.
//

import UIKit

extension UITableView {
    
    func registerAndGetCell<T: UITableViewCell>(_ type: T.Type) -> T {
        let cellID = String(describing: type)
        if let cell = dequeueReusableCell(withIdentifier: cellID) as? T {
            return cell
        }
        register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        return (dequeueReusableCell(withIdentifier: cellID) as? T)!
    }
}

