//
//  LoginViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 18/10/23.
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
    
    override func viewWillAppear(_ animated: Bool) {
        textEmail.text = ""
        textPassword.text = ""
    }
    
    @IBAction private func didTapOnSignUp() {
        if let signUpVc = SpiceSagaStoryBoards.main.getViewController(SignUpViewController.self) {
            navigationController?.pushViewController(signUpVc, animated: true)
        }
    }
    
    @IBAction private func didTapOnSignIn() {
        guard let email = textEmail.text , let password = textPassword.text else { return  }
        if email.isEmpty {
            self.alertPresent(withTitle: "Invalid Email", message: "Please enter valid email")
        } else if password.isEmpty {
            self.alertPresent(withTitle: "Invalid Password", message: "Please enter valid password")
        } else {
            showLoader()
            viewModel.login(email: email, password: password) {
                self.hideLoader()
                self.moveToHome()
            } failure: {
                self.hideLoader()
                self.alertPresent(withTitle: "Opps..", message: "Invalid email or password")
            }
        }
        
    }
    
    private func moveToHome() {
        if let homeVc = SpiceSagaStoryBoards.main.getViewController(HomeTabViewController.self) {
            
            navigationController?.pushViewController(homeVc, animated: true)
        }
    }
}
