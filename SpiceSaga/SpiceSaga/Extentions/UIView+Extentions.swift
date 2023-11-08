//
//  UIView+Extentions.swift
//  SpiceSaga
//
//  Created by psagc on 18/10/23.
//

import UIKit
import SwiftLoader

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}


extension UIViewController {

  func alertPresent(withTitle title: String, message : String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        print("You've pressed OK Button")
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
    
    func showLoader() {
        DispatchQueue.main.async {
            SwiftLoader.show(animated: true)
        }        
    }
    
    func showLoader(message: String) {
        DispatchQueue.main.async {
            SwiftLoader.show(title: message, animated: true)
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            SwiftLoader.hide()
        }
    }
}

extension UIViewController {
    func popToViewController<T: UIViewController>(_ type: T.Type,animation: Bool) {
        for vc in navigationController?.viewControllers ?? []{
            if vc.isKind(of: type.self) {
                navigationController?.popToViewController(vc, animated: animation)
                break
            }
        }
    }
}
