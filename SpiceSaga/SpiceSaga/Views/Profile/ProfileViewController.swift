//
//  ProfileViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 11/12/23.
//

import UIKit

struct Settiings {
    var name:  SettingsName
}
struct SettingsSection {
    var sectionTitle: String
    var settings: [Settiings] = [Settiings]()
}

enum SettingsName {
    case profile
    case appInformation
    case saveRecipe
    case numberOfRecipes(Int)
    case appSettings
    case logout
}

extension SettingsName {
    var title: String {
        switch self {
        case .profile:
            return ""
        case .appInformation:
            return "App Information & Features"
        case .saveRecipe:
            return "Saved Recipe"
        case .numberOfRecipes(let recipes):
            return "Number of recipe \(recipes)"
        case .appSettings:
            return "App Settings"
        case .logout:
            return "Logout"
        }
    }
}

class ProfileViewController: UIViewController {
    
    @IBOutlet var tableViewSettings: UITableView!
    
    var allSettings: [SettingsSection] = [SettingsSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allSettings[1].settings[1].name = .numberOfRecipes(FirebaseRMDatabase.shared.numberOfRecipes)
        tableViewSettings.reloadData()
        
    }
    private func prepareView() {
        
        allSettings.append(SettingsSection(sectionTitle: "User", settings: [Settiings(name: .profile),Settiings(name: .appInformation)]))
        allSettings.append(SettingsSection(sectionTitle: "Recipe", settings: [Settiings(name: .saveRecipe),Settiings(name: .numberOfRecipes(FirebaseRMDatabase.shared.numberOfRecipes))]))
        allSettings.append(SettingsSection(sectionTitle: "Settings", settings: [Settiings(name: .appSettings),Settiings(name: .logout)]))
        
        
    }
    private func logoutUser() {
        let alertController: UIAlertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout from the app? all of your saved recipes will be losted.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            FirebaseAuthManager.shared.logoutUser()
            SpiceSagaDataServices.shared.deleteAllData()
            self.tabBarController?.popToViewController(LoginViewController.self, animation: true)
        }))
        present(alertController, animated: true)
    }
    
    private func moveToSavedRecivedRecipes() {
        if let savedRecipeVc = SpiceSagaStoryBoards.main.getViewController(SavedRecipeViewController.self) {
            navigationController?.pushViewController(savedRecipeVc, animated: true)
        }
    }
    
    private func moveToAppSettings() {
        if let appSettingsVc = SpiceSagaStoryBoards.main.getViewController(AppSettingsViewController.self) {
            navigationController?.pushViewController(appSettingsVc, animated: true)
        }
    }
    
    private func moveToEditProfile() {
        if let editProfileVc = SpiceSagaStoryBoards.main.getViewController(EditProfileViewController.self) {
            navigationController?.pushViewController(editProfileVc, animated: true)
        }
    }
    
    private func moveToAppInfo() {
        if let appInfoVc = SpiceSagaStoryBoards.main.getViewController(AppInfoViewController.self) {
            navigationController?.pushViewController(appInfoVc, animated: true)
        }
    }
}
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        allSettings.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allSettings[section].settings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.registerAndGetCell(UserProfileCell.self)
            cell.prepareUserDetails()
            return cell
        }
        let cell = tableView.registerAndGetCell(SettingsCell.self)
        let settingsDetails = allSettings[indexPath.section].settings[indexPath.row]
        cell.settings = settingsDetails
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch allSettings[indexPath.section].settings[indexPath.row].name {
            
        case .profile:
            moveToEditProfile()
        case .saveRecipe:
            moveToSavedRecivedRecipes()
        case .appSettings:
            moveToAppSettings()
        case .logout:
            logoutUser()
        case .appInformation:
            moveToAppInfo()
        case .numberOfRecipes:
            print("")
        }
    }
}
