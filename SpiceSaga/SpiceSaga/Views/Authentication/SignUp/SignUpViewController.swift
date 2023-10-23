//
//  SignUpViewController.swift
//  SpiceSaga
//
//  Created by psagc on 18/10/23.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction private func didTapOnback() {
        moveToLogin()
    }
    
    @IBAction private func didTapOnLogin() {
        moveToLogin()
    }
    
    @IBAction private func didTapOnNext() {
        moveToSignUp2()
    }
    
    private func moveToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    private func moveToSignUp2() {
        if let signUpVc2 = SpiceSagaStoryBoards.main.getViewController(SignupVC2.self) {
            navigationController?.pushViewController(signUpVc2, animated: true)
        }
    }
}
