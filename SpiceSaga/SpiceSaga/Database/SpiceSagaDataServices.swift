//
//  SpiceSagaDataServices.swift
//  SpiceSaga
//
//  Created by psagc on 28/11/23.
//

import Foundation
import CoreData

enum SpiceSagaDBEntities {
    case savedRecipes
}
extension SpiceSagaDBEntities {
    var name: String {
        switch self {
        case .savedRecipes:
            return "SavedRecipes"
        }
    }
}

class SpiceSagaDataServices {
    
    static var shared: SpiceSagaDataServices = SpiceSagaDataServices()
    
    private let persistantManager = AppDelegate.shared.persistentContainer.viewContext
    
    func saveRecipe(recipe: Recipe) {
        let newRecipe = NSEntityDescription.insertNewObject(forEntityName: SpiceSagaDBEntities.savedRecipes.name, into: persistantManager)
        newRecipe.setValue(recipe.id, forKey: "id")
        newRecipe.setValue(recipe.description, forKey: "recipeDesciption")
        newRecipe.setValue(recipe.duration, forKey: "duration")
        if let ingredientsdata = try? NSKeyedArchiver.archivedData(withRootObject: recipe.ingredients, requiringSecureCoding: false) {
            newRecipe.setValue(ingredientsdata, forKey: "ingredients")
        }
        if let stepsData = try? NSKeyedArchiver.archivedData(withRootObject: recipe.steps, requiringSecureCoding: false) {
            newRecipe.setValue(stepsData, forKey: "steps")
        }
        newRecipe.setValue(recipe.thumbUrl, forKey: "thumbUrl")
        newRecipe.setValue(recipe.type, forKey: "type")
        newRecipe.setValue(recipe.userID, forKey: "userID")
        newRecipe.setValue(recipe.userName, forKey: "userName")
        newRecipe.setValue(recipe.userProfileImage, forKey: "userProfileImage")
        newRecipe.setValue(recipe.videoUrl, forKey: "videoUrl")
        newRecipe.setValue(recipe.region, forKey: "region")
        newRecipe.setValue(recipe.name, forKey: "name")
        newRecipe.setValue(recipe.calaroies, forKey: "calaroies")
        
        save()
    }

    private func save() {
        do {
            try persistantManager.save()
            print("✅✅✅✅ Data Saved ✅✅✅✅")
        } catch {
            print("❌❌❌❌❌  Error Saving Data \(error.localizedDescription) ❌❌❌")
        }
    }
    
    var allSaveRecipes: [Recipe] {
        let data = makeFetchRequest(entity: .savedRecipes)
        let recipes = data.compactMap({Recipe(object: $0)})
        return recipes
    }
    
    private func makeFetchRequest(entity: SpiceSagaDBEntities) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name)
        do {
            let data = try persistantManager.fetch(request) as? [NSManagedObject]  ?? []
            return data
        } catch {
            print("❌❌❌ Error fetching data \(error.localizedDescription) ❌❌❌")
        }
        return []
    }
    
    func removeSaved(recipe: Recipe) {
        let allRecipes = makeFetchRequest(entity: .savedRecipes)
        
        for recipeDetail in allRecipes {
            let details = Recipe(object: recipeDetail)
            if details.id == recipe.id {
                self.persistantManager.delete(recipeDetail)
            }
        }
        save()
    }
}
