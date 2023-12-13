//
//  RecipeImagesViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 07/11/23.
//

import UIKit
import AVFoundation

struct RecipeDetails {
    var name: String = ""
    var type : String = ""
    var region: String = ""
    var duration: String = ""
    var calories: Int = 0
    var thumbnail: UIImage = UIImage()
    var ingredients: [IngredientDetails] = [IngredientDetails]()
}

class RecipeImagesViewController: UIViewController {

    @IBOutlet var tableViewSteps: UITableView!
    @IBOutlet var labelAddStepPlaceHolder: UILabel!
    @IBOutlet var labelRecipeName: UILabel!
    @IBOutlet var imageViewThumbnail: UIImageView!
    
    var step: Int = 1
    var recipeSteps: [String] = [String]()
    var recipeDetails: RecipeDetails?
    var videoURL: URL?
    var ingredientsDetails: [String: String] = [:]
    var thumailUrl: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareView()
    }
    
    private func prepareView() {
        labelRecipeName.text = recipeDetails?.name ?? ""
    }

    
    @IBAction private func didTapOnAddStep() {
        let alertStep: UIAlertController = UIAlertController(title: "Add Step", message: "Step \(step)", preferredStyle: .alert)
        alertStep.addTextField { textField in
            
        }
        alertStep.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertStep.addAction(UIAlertAction(title: "Add", style: .default,handler: { _ in
            if let stepDetails = alertStep.textFields?[0].text {
                self.recipeSteps.append(stepDetails)
                self.tableViewSteps.reloadData()
                self.labelAddStepPlaceHolder.isHidden = true
            }
        }))
        present(alertStep, animated: true)
    }
    
    @IBAction private func didTapOnBack() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func didTapOnPublish() {
        if let ingredient = recipeDetails?.ingredients.first{
            showLoader(message: "Please wait while uploading..")
            uploadIngredients(ingredients: ingredient)
        }
        
    }
    @IBAction private func didTapOnUploadVideo() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
          imagePickerController.delegate = self
          imagePickerController.mediaTypes = ["public.movie"]

        present(imagePickerController, animated: true, completion: nil)
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }

    func uploadIngredients(ingredients: IngredientDetails) {
        if let image = ingredients.ingredientImage.jpegData(compressionQuality: 0.1) {
            FirebaseRealTimeStorage.shared.uploadImage(name: ingredients.name, image: image) { url in
                print("Test")
                print(url)
                self.ingredientsDetails[ingredients.name] = url ?? ""
                self.recipeDetails?.ingredients.removeAll(where: {$0.name == ingredients.name})
                if self.recipeDetails?.ingredients.isEmpty ?? false {
                    if let thumnailImage = self.imageViewThumbnail.image?.pngData() {
                        FirebaseRealTimeStorage.shared.uploadImage(name: self.recipeDetails?.name ?? "", image: thumnailImage) { url in
                            self.thumailUrl = url ?? ""
                            self.uploadVideo()
                        }
                    }
                } else {
                    if let nextIngredient = self.recipeDetails?.ingredients.first {
                        self.uploadIngredients(ingredients: nextIngredient)
                    }
                }
            }
        }
        
    }
    
    private func uploadVideo() {
        do {
            if let videoURL = videoURL , let details = self.recipeDetails, let user = FirebaseAuthManager.shared.currentUser{
                let videoData = try Data(contentsOf: videoURL)
                FirebaseRealTimeStorage.shared.uploadVideo(name: details.name, image: videoData) { url in
                    var i = 0
                    self.hideLoader()
                    
                    let steps: [String: String] = self.recipeSteps.reduce(into: [:], { result, next in
                        result["Step\(i)"] = next
                        i += 1
                    })

                    if let vUrl = url {
                        FirebaseRMDatabase.shared.addNewRecipe(recipe: Recipe(id: "",name: details.name, description: details.duration, type: details.type, region: details.region, thumbUrl: self.thumailUrl, videoUrl: vUrl, userID: FirebaseAuthManager.shared.userID, userName: user.userName, userProfileImage: user.profileUrl, duration: details.duration, calaroies: details.calories, ingredients: self.ingredientsDetails, steps: steps))
                        
                    }
                    NotificationCenter.default.post(name: .refreshRecipes, object: nil)
                    DispatchQueue.main.async {
                        self.popToViewController(HomeTabViewController.self, animation: true)
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
extension RecipeImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeSteps.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGetCell(RecipeStepsCell.self)
        cell.step = recipeSteps[indexPath.row]
        return cell
    }
}

extension RecipeImagesViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let vUrl =  info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                self.videoURL = vUrl
                self.imageViewThumbnail.image = self.getThumbnailImage(forUrl: vUrl)
            }
            print("videoURL:\(String(describing: self.videoURL))")
            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
