//
//  AddRecipeVC.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 07/11/23.
//

import UIKit

class AddNewRecipeViewController: UIViewController {

    @IBOutlet var buttonRecipeType: UIButton!
    @IBOutlet var buttonRegionType: UIButton!
    @IBOutlet var labelDuration: UILabel!
    @IBOutlet var labelCalories: UILabel!
    @IBOutlet var textFieldRecipeName: UITextField!
    @IBOutlet var tableViewIngredient: UITableView!
    
    var allRegions: [String] = ["India", "America", "Europ"]
    var recipeDetails: RecipeDetails = RecipeDetails()
    var ingredients: [IngredientDetails] = [IngredientDetails]()
    
    var isImageSelected: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func didTapOnBack() {
        navigationController?.popViewController(animated: true)
    }

    
    @IBAction private func didTapOnType() {
        let alertControllerRecipeType = UIAlertController(title: "Recipe Type", message: "Select recipe type !", preferredStyle: .actionSheet)
        alertControllerRecipeType.addAction(UIAlertAction(title: "Breakfast", style: .default, handler: { _ in
            self.buttonRecipeType.setTitle("Breakfast", for: .normal)
            self.recipeDetails.type = "Breakfast"
        }))
        alertControllerRecipeType.addAction(UIAlertAction(title: "Lunch", style: .default, handler: { _ in
            self.buttonRecipeType.setTitle("Lunch", for: .normal)
            self.recipeDetails.type = "Lunch"
        }))
        alertControllerRecipeType.addAction(UIAlertAction(title: "Dinner", style: .default, handler: { _ in
            self.buttonRecipeType.setTitle("Dinner", for: .normal)
            self.recipeDetails.type = "Dinner"
        }))
        alertControllerRecipeType.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertControllerRecipeType, animated: true)
    }
    
    @IBAction private func didTapOnSelectRegion() {
        let alertControllerRegion = UIAlertController(title: "Recipe region", message: "Select recipe region !", preferredStyle: .actionSheet)
        for region in  allRegions {
            alertControllerRegion.addAction(UIAlertAction(title: region, style: .default, handler: { _ in
                self.buttonRegionType.setTitle(region, for: .normal)
                self.recipeDetails.region = region
            }))
        }
        
        alertControllerRegion.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertControllerRegion, animated: true)
    }
    
    @IBAction private func didChangedDuration(sender: UIStepper) {
        labelDuration.text = "\(Int(sender.value) ) Min"
        self.recipeDetails.duration = "\(Int(sender.value) ) Min"
    }
    
    @IBAction private func didChangedCalories(sender: UIStepper) {
        labelCalories.text = "\(Int(sender.value))"
        self.recipeDetails.calories = Int(sender.value)
    }
    
    @IBAction private func didTapOnNext() {
        if textFieldRecipeName.text?.isEmpty ?? false {
            self.alertPresent(withTitle: "Alert", message: "Please enter recipe name")
        }
        if let reciepImagesViewController = SpiceSagaStoryBoards.main.getViewController(RecipeImagesViewController.self) {
            recipeDetails.name = textFieldRecipeName?.text ?? ""
            recipeDetails.ingredients = ingredients
            reciepImagesViewController.recipeDetails = recipeDetails
            navigationController?.pushViewController(reciepImagesViewController, animated: true)
        }
    }
    
    @IBAction private func didTapOnAddIngredients() {
        let alertSelectImage = UIAlertController(title: "Select Image", message: "Select thumbain image that will be visable to everyone.", preferredStyle: .actionSheet)
        alertSelectImage.addAction(UIAlertAction(title: "Camara", style: .default,handler: { _ in
            self.openImageController(source: .camera)
        }))
        alertSelectImage.addAction(UIAlertAction(title: "Photos", style: .default,handler: { _ in
            self.openImageController(source: .photoLibrary)
        }))
        alertSelectImage.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertSelectImage, animated: true)
    }
    
    private func openImageController(source: UIImagePickerController.SourceType) {
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func moveToAddIngredient(image: UIImage) {
        if let addIngredientsViewController = SpiceSagaStoryBoards.main.getViewController(AddIngredientsViewController.self) {
            addIngredientsViewController.ingredientImage = image
            addIngredientsViewController.didAddedIngredient = { newIngredient in
                self.ingredients.append(newIngredient)
                self.tableViewIngredient.reloadData()
            }
            present(addIngredientsViewController, animated: true)
        }
    }
}
extension AddNewRecipeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.moveToAddIngredient(image: image)
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
extension AddNewRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGetCell(AddedIngredientsCell.self)
        cell.detail = ingredients[indexPath.row]
        return cell
    }
    
    
}
