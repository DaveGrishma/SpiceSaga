//
//  AddIngredientsViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 07/11/23.
//

import UIKit

struct IngredientDetails {
    var name: String
    var ingredientImage: UIImage
}

class AddIngredientsViewController: UIViewController {

    @IBOutlet private var imageViewIngredient: UIImageView!
    @IBOutlet private var textFieldAddIngredient: UITextField!
    
    var ingredientImage: UIImage?
    var didAddedIngredient:((IngredientDetails) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareView()
    }
    
    private func prepareView() {
        if let image = ingredientImage {
            imageViewIngredient.image = image
        }
    }

    @IBAction private func didTapOnAdd() {
        if textFieldAddIngredient.text?.isEmpty ?? false {
            alertPresent(withTitle: "Error", message: "Please enter valid ingredient name")
        } else {
            guard let image = imageViewIngredient?.image else { return  }
            let ingredient = IngredientDetails(name: textFieldAddIngredient.text ?? "", ingredientImage: image)
            didAddedIngredient?(ingredient)
            dismiss(animated: true)
        }
    }
}
