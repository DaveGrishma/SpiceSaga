//
//  LoginViewController.swift
//  SpiceSaga
//
//  Created by psagc on 18/10/23.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func didTapOnSignUp() {
        if let signUpVc = SpiceSagaStoryBoards.main.getViewController(SignUpViewController.self) {
            navigationController?.pushViewController(signUpVc, animated: true)
        }
    }

}
