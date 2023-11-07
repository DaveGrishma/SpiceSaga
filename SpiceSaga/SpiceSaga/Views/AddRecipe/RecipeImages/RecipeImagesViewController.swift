//
//  RecipeImagesViewController.swift
//  SpiceSaga
//
//  Created by psagc on 07/11/23.
//

import UIKit

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
    
    var step: Int = 1
    var recipeSteps: [String] = [String]()
    var recipeDetails: RecipeDetails?
    
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
        if let ingredientImage = recipeDetails?.ingredients.first?.ingredientImage.jpegData(compressionQuality: 0.1) {
            FirebaseRealTimeStorage.shared.uploadImage(name: "chees", image: ingredientImage) { url in
                print(url)
            }
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
