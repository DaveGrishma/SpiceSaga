//
//  SignUpViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 18/10/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet private var textName: UITextField!
    @IBOutlet private var textEmail: UITextField!
    @IBOutlet private var textPassword: UITextField!
    
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
        
        if !ValidateClass.isValidUsername(for: textName.text ?? "") {
            self.alertPresent(withTitle: "Invalid Username", message: "Please enter valid username")
        } else if !ValidateClass.isValidEmail(for: (textEmail.text ?? "")) {
            self.alertPresent(withTitle: "Invalid Email", message: "Please enter valid email")
        } else if !ValidateClass.isPasswordValid(for: (textPassword.text ?? "")) {
            self.alertPresent(withTitle: "Invalid Password", message: "Please enter valid password. password shuold be 6 to 8 character and should contain 1 Alphabet and 1 spacial character.")
        } else {
            if let userDetailsVc = SpiceSagaStoryBoards.main.getViewController(UserDetailsViewController.self) {
                userDetailsVc.textName = textName.text
                userDetailsVc.textEmail = textEmail.text
                userDetailsVc.textPassword = textPassword.text
                navigationController?.pushViewController(userDetailsVc, animated: true)
            }
        }
        
        
    }
    
    private func moveToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
}
