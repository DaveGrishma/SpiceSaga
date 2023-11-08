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
    
}

extension MyRecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGetCell(MyRecipeCell.self)
        cell.recipeDetails = myRecipes[indexPath.row]
        return cell
    }
}
