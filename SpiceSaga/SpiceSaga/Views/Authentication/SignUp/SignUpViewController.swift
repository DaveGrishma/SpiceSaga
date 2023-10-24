//
//  SignUpViewController.swift
//  SpiceSaga
//
//  Created by psagc on 18/10/23.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction private func didTapOnback() {
        moveToLogin()
    }
    
    @IBAction private func didTapOnLogin() {
        moveToLogin()
    }
    
    @IBAction private func didTapOnNext() {
        if let userDetailsVc = SpiceSagaStoryBoards.main.getViewController(UserDetailsViewController.self) {
            userDetailsVc.textName = textName.text
            userDetailsVc.textEmail = textEmail.text
            userDetailsVc.textPassword = textPassword.text
            navigationController?.pushViewController(userDetailsVc, animated: true)
        }
    }
    
    private func moveToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    
}
