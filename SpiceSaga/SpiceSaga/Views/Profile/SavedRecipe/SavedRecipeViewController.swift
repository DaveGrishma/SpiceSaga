//
//  SavedRecipeViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 11/12/23.
//

import UIKit

class SavedRecipeViewController: UIViewController {

    var savedRecipes: [Recipe] = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareView()
    }
    
    private func prepareView() {
        savedRecipes.append(contentsOf: SpiceSagaDataServices.shared.allSaveRecipes)
    }

    // MARK: - Action Methods
    @IBAction private func didTapOnBack() {
        navigationController?.popViewController(animated: true)
    }
}
extension SavedRecipeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedRecipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGetCell(RecipeBookTableViewCell.self)
        cell.recipeDetails = savedRecipes[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailRecipeVc = SpiceSagaStoryBoards.main.getViewController(DetailRecipeViewController.self) else { return  }
        detailRecipeVc.detailRecieps = self.savedRecipes[indexPath.row]
        detailRecipeVc.route = .savedRecipe(self.savedRecipes[indexPath.row])
        navigationController?.pushViewController(detailRecipeVc, animated: true)
    }
}
