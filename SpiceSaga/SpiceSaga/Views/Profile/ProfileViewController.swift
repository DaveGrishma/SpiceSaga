//
//  ProfileViewController.swift
//  SpiceSaga
//
//  Created by psagc on 24/10/23.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func didTapOnLogout() {
        FirebaseAuthManager.shared.logoutUser()
       // self.tabBarController?.navigationController?.popViewController(animated: true)
        self.navigationController?.popToViewController(LoginViewController.self, animation: true)
    }
}
