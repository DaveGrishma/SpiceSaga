//
//  LoginViewController.swift
//  SpiceSaga
//
//  Created by psagc on 18/10/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private var textEmail: UITextField!
    @IBOutlet private var textPassword: UITextField!
    
    lazy var viewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func didTapOnSignUp() {
        if let signUpVc = SpiceSagaStoryBoards.main.getViewController(SignUpViewController.self) {
            navigationController?.pushViewController(signUpVc, animated: true)
        }
    }

    @IBAction private func didTapOnSignIn() {
        guard let email = textEmail.text , let password = textPassword.text else { return  }        
        viewModel.login(email: email, password: password) {
            self.moveToHome()
        } failure: {
            
        }

    }
    
    private func moveToHome() {
        if let homeVc = SpiceSagaStoryBoards.main.getViewController(HomeTabViewController.self) {
            
            navigationController?.pushViewController(homeVc, animated: true)
        }
    }
}
