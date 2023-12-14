//
//  AppInfoViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 14/12/23.
//

import UIKit
import WebKit

class AppInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
    }
    
    
    // MARK: - Action Methods
    
    @IBAction private func didTapOnBack() {
        navigationController?.popViewController(animated: true)
    }

    

}
