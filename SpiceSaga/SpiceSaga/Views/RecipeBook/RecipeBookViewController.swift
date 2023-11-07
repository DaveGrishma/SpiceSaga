//
//  RecipeBookVC.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 05/11/23.
//

import UIKit

class RecipeBookViewController: UIViewController {

    @IBOutlet var recipeTableView: UITableView!
    
    var allRecieps: [Recipe] = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    private func setUI() {
        navigationController?.navigationBar.isHidden = true
        recipeTableView.tableHeaderView = RecipeBookListHeader.shared
        FirebaseRMDatabase.shared.getRecipes { recipes in
            self.allRecieps.append(contentsOf: recipes)
            DispatchQueue.main.async {
                self.recipeTableView.reloadData()
            }
        }
       // FirebaseRMDatabase.shared.addNewRecipe(recipe: Recipe(name: "Creamy Garlic Lemon Pasta", description: "This creamy garlic lemon pasta is a quick and delightful dish that combines the flavors of garlic and fresh lemon with a velvety cream sauce. It's a perfect balance of richness and zest, making it a satisfying yet refreshing meal.", type: "Lunch", region: "India", thumbUrl: "https://pinchandswirl.com/wp-content/uploads/2021/12/Lemon-Garlic-Chicken-Pasta__.jpg", videoUrl: "https://pinchandswirl.com/wp-content/uploads/2021/12/Lemon-Garlic-Chicken-Pasta__.jpg", userID: "abvx6rw6r4PDQ9pZoFWdpcajgIB3", userName: "Grishma Dave", userProfileImage: "https://firebasestorage.googleapis.com/v0/b/recipeapp-86e78.appspot.com/o/abvx6rw6r4PDQ9pZoFWdpcajgIB3.png?alt=media&token=445ef71d-a73f-42cf-bd2c-77d26e403d9e&_gl=1*1tibwdv*_ga*NTQ4MDAzOTcyLjE2OTU5ODcyODk.*_ga_CW55HF8NVT*MTY5OTI1MTIxOS4xNS4xLjE2OTkyNTE5MTguMjAuMC4w",duration: "120 Min",calaroies: 20, ingredients: ["butter":"https://cdn.britannica.com/27/122027-050-EAA86783/Butter.jpg","Garlic":"https://andamangreengrocers.com/wp-content/uploads/2021/12/garlic.jpg","Lemon":"https://www.starhealth.in/blog/wp-content/uploads/2022/07/Picture-of-lemons-cut-in-halves.jpg"]))
    }

}
extension RecipeBookViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRecieps.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGetCell(RecipeBookTableViewCell.self)
        cell.recipeDetails = allRecieps[indexPath.row]
        return cell
    }
    
}
