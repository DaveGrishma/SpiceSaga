//
//  UserDetailsViewController.swift
//  SpiceSaga
//
//  Created by psagc on 19/10/23.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet private var buttonCountry: UIButton!
    @IBOutlet private var buttomProfileImage: UIButton!
    @IBOutlet private var labelUsername: UILabel!
    
    var textEmail: String?
    var textName: String?
    var textPassword: String?
    var countrySelected: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareView()
    }
    
    
    private func prepareView() {
        guard let name = textName else { return  }
        labelUsername.text = "Hi, \(name)"
    }
    
    @IBAction private func didTapOnBack() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func didTapOnSubmit() {
        guard let email = textEmail, let name = textName, let password = textPassword, let countryName: String = countrySelected else { return  }
        FirebaseAuthManager.shared.createUserAccount(email: email, password: password) {
            if let image = self.buttomProfileImage.imageView?.image?.pngData() {
                FirebaseRealTimeStorage.shared.uploadMedia(name: name, country: countryName, image: image) { url in
                    DispatchQueue.main.async {
                        self.moveToHome()
                    }
                }
            }
        }
    }
    
    @IBAction private func didTapOnSelectImage() {
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction private func didTapOnSelectCountry() {
        let countryAlertController: UIAlertController = UIAlertController(title: "Select Country", message: "", preferredStyle: .actionSheet)
        countryAlertController.addAction(UIAlertAction(title: "Canada", style: .default,handler: { _ in
            self.countrySelected = "Canada"
            self.buttonCountry.setTitle("Canada", for: .normal)
        }))
        countryAlertController.addAction(UIAlertAction(title: "USA", style: .default,handler: { _ in
            self.countrySelected = "USA"
            self.buttonCountry.setTitle("USA", for: .normal)
        }))
        countryAlertController.addAction(UIAlertAction(title: "India", style: .default,handler: { _ in
            self.countrySelected = "India"
            self.buttonCountry.setTitle("India", for: .normal)
        }))
        countryAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(countryAlertController, animated: true)
    }
    
    private func moveToHome() {
        if let homeVc = SpiceSagaStoryBoards.main.getViewController(HomeTabViewController.self) {
            navigationController?.pushViewController(homeVc, animated: true)
        }
    }
    
}
extension UserDetailsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.buttomProfileImage.setImage(image, for: .normal)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
