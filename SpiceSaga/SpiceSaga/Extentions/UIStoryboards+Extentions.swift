//
//  UIStoryboards+Extentions.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 18/10/23.
//

import UIKit

extension UIStoryboard {
    
    func getViewController<T:UIViewController>(_ type: T.Type) -> T? {
        let controllerID: String = String(describing: type)
        return self.instantiateViewController(withIdentifier: controllerID) as? T ?? nil
    }
}

