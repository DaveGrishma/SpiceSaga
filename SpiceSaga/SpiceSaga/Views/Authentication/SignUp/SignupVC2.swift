//
//  SignupVC2.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 22/10/23.
//

import UIKit

class SignupVC2: UIViewController {

    @IBOutlet private var imageProfile: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction private func didTapOnSignUp() {
        moveToHome()
    }
    
    @IBAction private func didTapOnback() {
        moveToLogin()
    }
    
    @IBAction private func didTapOnImage() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    private func moveToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    private func moveToHome() {
        if let homeVC = SpiceSagaStoryBoards.main.getViewController(HomeViewController.self) {
            navigationController?.pushViewController(homeVC, animated: true)
        }
    }
}

extension SignupVC2: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            imageProfile?.image = image
        }
    }
}
