//
//  EditProfileViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 14/12/23.
//

import UIKit
import Kingfisher

class EditProfileViewController: UIViewController {

    @IBOutlet var buttonProfilePicture: UIButton!
    @IBOutlet var textUsername: UITextField!
    @IBOutlet var buttonCountry: UIButton!
    
    var isProfileDetailsChanged: Bool = false
    var userName: String = ""
    var isImageSelected: Bool = false
    var countrySelected: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareView()
    }
    
    private func prepareView() {
        textUsername.text = FirebaseAuthManager.shared.currentUser?.userName ?? ""
        countrySelected = FirebaseAuthManager.shared.currentUser?.country ?? ""
        self.buttonCountry.setTitle(countrySelected, for: .normal)
        let userId = FirebaseAuthManager.shared.userID
        FirebaseRealTimeStorage.shared.getProfilePictureURL(forUserID: userId) { url in
            if let userUrl = url {
                self.buttonProfilePicture.kf.setImage(with: userUrl, for: .normal)
            }
        }
    }
    
    // MARK: - Action Method
    @IBAction private func didTapOnBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnEditPicture() {
        let alertSelectImage = UIAlertController(title: "Select Image", message: "Please Select profile image.", preferredStyle: .actionSheet)
        alertSelectImage.addAction(UIAlertAction(title: "Camera", style: .default,handler: { _ in
            self.openImageController(source: .camera)
        }))
        alertSelectImage.addAction(UIAlertAction(title: "Photos", style: .default,handler: { _ in
            self.openImageController(source: .photoLibrary)
        }))
        alertSelectImage.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertSelectImage, animated: true)
    }
    
    @IBAction private func didTapOnSubmit() {
        if !isProfileDetailsChanged {
                    isProfileDetailsChanged = (textUsername.text ?? "") != (FirebaseAuthManager.shared.currentUser?.userName ?? "")
        }
        
        if isImageSelected {
            guard let image = buttonProfilePicture.imageView?.image else { return  }
            showLoader(message: "Updating Profile image..")
            FirebaseAuthManager.shared.updateProfilePicture(profileImage: image, name: textUsername.text ?? "", country: countrySelected) { error in
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.showMessage(message: "User details updated succssfully.")
                    
                }
            }
        } else if isProfileDetailsChanged {
            FirebaseAuthManager.shared.updateUserDetails(name: textUsername.text ?? "", country: buttonCountry.titleLabel?.text ?? "") {
                self.showMessage(message: "User details updated succssfully.")
            }
        }
    }
    @IBAction private func didTapOnSelectCountry() {
        let countryAlertController: UIAlertController = UIAlertController(title: "Select Country", message: "", preferredStyle: .actionSheet)
        countryAlertController.addAction(UIAlertAction(title: "Canada", style: .default,handler: { _ in
            self.countrySelected = "Canada"
            self.isProfileDetailsChanged = true
            self.buttonCountry.setTitle("Canada", for: .normal)
        }))
        countryAlertController.addAction(UIAlertAction(title: "USA", style: .default,handler: { _ in
            self.countrySelected = "USA"
            self.isProfileDetailsChanged = true
            self.buttonCountry.setTitle("USA", for: .normal)
        }))
        countryAlertController.addAction(UIAlertAction(title: "India", style: .default,handler: { _ in
            self.countrySelected = "India"
            self.isProfileDetailsChanged = true
            self.buttonCountry.setTitle("India", for: .normal)
        }))
        countryAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(countryAlertController, animated: true)
    }
   
    // MARK: - Helper Methods
    private func openImageController(source: UIImagePickerController.SourceType) {
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func showMessage(message: String) {
        let alertUpdated: UIAlertController = UIAlertController(title: "Updated", message: message, preferredStyle: .alert)
        alertUpdated.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: .refreshRecipes, object: nil)
        }))
        present(alertUpdated, animated: true)
    }
}
extension EditProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.buttonProfilePicture.setImage(image, for: .normal)
        }
        isImageSelected = true
        isProfileDetailsChanged = true
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
