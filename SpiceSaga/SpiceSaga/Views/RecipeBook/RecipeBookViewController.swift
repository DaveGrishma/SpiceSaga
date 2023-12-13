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
    var filterRecipes: [Recipe] = [Recipe]()
    var filterRecipeType: RecipeType = .all
    var filterRegion: RecipeReligionFilter = .all
    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUI()
    }
    private func setUI() {
        navigationController?.navigationBar.isHidden = true
        let tableHeader = RecipeBookListHeader.shared
        tableHeader.setupPlaceHolderForSearch()
        tableHeader.didSearch = { searchText in
            self.searchText = searchText
            self.searchFor(text: searchText)
        }
        tableHeader.didSelectedFilter = {
            self.moveToFilter()
        }
        if let user = FirebaseAuthManager.shared.currentUser {
            tableHeader.userName = user.userName
        }
        recipeTableView.tableHeaderView = tableHeader
        loadRecipes()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshRecipes), name: .refreshRecipes, object: nil)
        let refresh = UIRefreshControl()
        recipeTableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshRecipes), for: .valueChanged)
    }
    
    @objc func refreshRecipes() {
        loadRecipes()
    }
    
    private func loadRecipes() {
        FirebaseRMDatabase.shared.getRecipes { recipes in
            self.allRecieps.removeAll()
            self.filterRecipes.removeAll()
            self.allRecieps.append(contentsOf: recipes)
            self.filterRecipes.append(contentsOf: recipes)
            self.reloadWithFilterData()
            self.recipeTableView.refreshControl?.beginRefreshing()
            DispatchQueue.main.async {
                self.recipeTableView.refreshControl?.endRefreshing()
                self.recipeTableView.reloadData()
            }
        }
    }
    
    private func searchFor(text: String) {
        filterRecipes.removeAll()
        let arraySearch = allRecieps.filter({$0.name.lowercased().hasPrefix(text.lowercased())})
        filterRecipes.append(contentsOf: arraySearch)
        self.recipeTableView.reloadData()
    }
    
    private func moveToFilter() {
        
        if let filterVc = SpiceSagaStoryBoards.main.getViewController(FilterViewController.self) {
            filterVc.filterRecipeType = self.filterRecipeType
            filterVc.filterRegion = self.filterRegion
            filterVc.didFinishedWithFilters = { recipeRegion, recipeType in
                self.filterRecipeType = recipeType
                self.filterRegion = recipeRegion
                self.reloadWithFilterData()
            }
            present(filterVc, animated: true)
        }
    }
    
    func reloadWithFilterData() {
        var allFilteredRecipes = [Recipe]()
        
        if filterRecipeType != .all {
            allFilteredRecipes = self.allRecieps.filter({$0.type.lowercased().hasPrefix(filterRecipeType.displayValue.lowercased())})
        } else {
            allFilteredRecipes = self.allRecieps
        }
        
        if filterRegion != .all {
            allFilteredRecipes = allFilteredRecipes.filter({$0.region.lowercased().hasPrefix(filterRegion.displayValue.lowercased())})
        }
        
        if !self.searchText.isEmpty {
            allFilteredRecipes = allFilteredRecipes.filter({$0.name.lowercased().hasPrefix(self.searchText.lowercased())})
        }
        
        self.filterRecipes = allFilteredRecipes
        self.recipeTableView.reloadData()
    }
}
extension RecipeBookViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterRecipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGetCell(RecipeBookTableViewCell.self)
        cell.recipeDetails = filterRecipes[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailRecipeVc = SpiceSagaStoryBoards.main.getViewController(DetailRecipeViewController.self) else { return  }
        detailRecipeVc.detailRecieps = self.filterRecipes[indexPath.row]
        navigationController?.pushViewController(detailRecipeVc, animated: true)
    }
}
