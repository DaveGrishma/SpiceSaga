//
//  MyRecipesViewController.swift
//  SpiceSaga
//
//  Created by psagc on 07/11/23.
//

import UIKit

class MyRecipesViewController: UIViewController {

    @IBOutlet private var tableViewMyRecipes: UITableView!
    
    var myRecipes: [Recipe] = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareView()
    }
    
    private func prepareView() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshRecipes), name: .refreshRecipes, object: nil)
        loadRecipes()
        let headerView = MyRecipeHeaderView.shared
        headerView.didSelectedAdd = {
            self.moveToAddNewReciepe()
        }
        tableViewMyRecipes.tableHeaderView = headerView
    }
   
    @objc func refreshRecipes() {
        loadRecipes()
    }
    
    func loadRecipes() {
        FirebaseRMDatabase.shared.getMyRecipes { recipes in
            self.myRecipes.removeAll()
            self.myRecipes.append(contentsOf: recipes)
            DispatchQueue.main.async {
                self.tableViewMyRecipes.reloadData()
            }
        }
    }
    private func moveToAddNewReciepe() {
        guard let addRecipeVc = SpiceSagaStoryBoards.main.getViewController(AddNewRecipeViewController.self) else { return  }
        navigationController?.pushViewController(addRecipeVc, animated: true)
    }
    
    private func deleteRecipe(id: String) {
        let alertDelete = UIAlertController(title: "Remove Recipe", message: "Are you sure you want to remove this recipe? it'll be permently removed from you recipe book and won't be visable to others.", preferredStyle: .alert)
        alertDelete.addAction(UIAlertAction(title: "Remove", style: .default, handler: { _ in
            FirebaseRMDatabase.shared.deleteRecipe(id: id) {
                self.loadRecipes()
            }
        }))
        alertDelete.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alertDelete, animated: true)
    }
}

extension MyRecipesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGetCell(MyRecipeCell.self)
        cell.recipeDetails = myRecipes[indexPath.row]
        cell.didSelectedDelete = {
            self.deleteRecipe(id: self.myRecipes[indexPath.row].id)
        }
        return cell
    }
}
