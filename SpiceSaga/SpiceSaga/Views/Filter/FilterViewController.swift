//
//  FilterViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 11/12/23.
//

import UIKit

protocol FilterType {
    var displayValue: String { get }
}
enum RecipeReligionFilter : FilterType, CaseIterable {
    case indian
    case american
    case european
    case all
}


extension RecipeReligionFilter {
    var displayValue: String {
        switch self {
        case .indian:
            return "India"
        case .american:
            return "America"
        case .european:
            return "Europ"
        case .all:
            return "All"
        }
    }
}

enum RecipeType : FilterType, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case all
}

extension RecipeType {
    var displayValue: String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinner"
        case .all:
            return "All"
        }
    }
}

struct RecipeFilters {
    var filter: [FilterType]
}

class FilterViewController: UIViewController {

    var allFilters: [RecipeFilters] = [RecipeFilters]()
    var filterRecipeType: RecipeType = .all
    var filterRegion: RecipeReligionFilter = .all
    
    var didFinishedWithFilters:((_ recipeRegion:RecipeReligionFilter,_ recipeType:RecipeType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        allFilters.append(RecipeFilters(filter: RecipeReligionFilter.allCases))
        allFilters.append(RecipeFilters(filter: RecipeType.allCases))
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layoutSubviews()
    }
    @IBAction private func didTapOnClose() {
        dismiss(animated: true)
    }

    @IBAction private func didTapOnSubmit() {
        didFinishedWithFilters?(filterRegion,filterRecipeType)
        dismiss(animated: true)
    }
}
extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        allFilters.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allFilters[section].filter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGetCell(FilterCell.self)
        let filterName = allFilters[indexPath.section].filter[indexPath.row]
        cell.filter = filterName
        if let filter = filterName as? RecipeReligionFilter, filter == filterRegion{
            cell.accessoryType = .checkmark
        } else if let filter = filterName as? RecipeType, filter == filterRecipeType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let filter = allFilters[indexPath.section].filter[indexPath.row] as? RecipeReligionFilter {
            filterRegion = filter
        } else if let filter = allFilters[indexPath.section].filter[indexPath.row] as? RecipeType {
            filterRecipeType = filter
        }
        tableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Region"
        } else if section == 1 {
            return "Cooking Time"
        } else {
            return "Recipe Type"
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.white        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 50
    }
}
