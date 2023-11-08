//
//  FirebaseRMDatabase.swift
//  SpiceSaga
//
//  Created by psagc on 06/11/23.
//

import FirebaseDatabase

struct Recipe {
    var name: String
    var description: String
    var type: String
    var region: String
    var thumbUrl: String
    var videoUrl: String
    var userID: String
    var userName: String
    var userProfileImage: String
    var duration: String
    var calaroies: Int
    var ingredients: [String: String]
    var steps: [String: String]
}
class FirebaseRMDatabase {
    
    static var shared: FirebaseRMDatabase = FirebaseRMDatabase()
    private let rootRef = Database.database()
    
    func getRecipes(complition: @escaping(_ recipes: [Recipe]) -> Void) {
        let recipes = rootRef.reference(withPath: "RecipeApp/Recipes")
        
        recipes.getData { errror, snapshot in
            
            var recipes:[Recipe] = [Recipe]()
            print(snapshot) // Its print all values including Snap (User)
            print(snapshot?.value!)
                        
            if let allRecipes   = snapshot?.children.allObjects as? [DataSnapshot] {
                for details in allRecipes {
                    
                    if let recipeDetails = (details.value as? [String: Any]){
                        let ingredients = recipeDetails["ingredients"] as? [String: String] ?? [:]
                        
                        
                        recipes.append(Recipe(name: recipeDetails["name"] as? String ?? "", description: recipeDetails["desciption"] as? String ?? "", type: recipeDetails["type"] as? String ?? "", region: recipeDetails["region"] as? String ?? "", thumbUrl: recipeDetails["thumbUrl"] as? String ?? "", videoUrl: recipeDetails["videoUrl"] as? String ?? "", userID: recipeDetails["userID"] as? String ?? "", userName: recipeDetails["userName"] as? String ?? "", userProfileImage: "https://firebasestorage.googleapis.com:443/v0/b/recipeapp-86e78.appspot.com/o/C2C51527-C30C-4E24-A396-44A989309172.png?alt=media&token=b9252216-18a9-41e7-87f5-ef21032b673a",duration: recipeDetails["duration"] as? String ?? "",calaroies: recipeDetails["calories"] as? Int ?? 0,ingredients: ingredients, steps: [:]))
                    }
                    
                    
                    
                    
                }
                complition(recipes)
            }
        }
        
    }
    
    func addNewRecipe(recipe: Recipe) {
        
        let recipes = rootRef.reference(withPath: "RecipeApp").child("Recipes").childByAutoId()
        
        let newRecipeId = recipes.key
        recipes.setValue([
            "id": newRecipeId,
            "name": recipe.name,
            "desciption": recipe.description,
            "type": recipe.type,
            "region": recipe.region,
            "thumbUrl": recipe.thumbUrl,
            "userID": recipe.userID,
            "userProfileImage": recipe.userProfileImage,
            "videoUrl":recipe.videoUrl,
            "userName": recipe.userName,
            "ingredients": recipe.ingredients,
            "duration": recipe.duration,
            "steps": recipe.steps
        ])
    }
    
    func getMyRecipes(complition: @escaping(_ recipes: [Recipe]) -> Void) {
        let recipes = rootRef.reference(withPath: "RecipeApp/Recipes")
        recipes.getData { errror, snapshot in
            
            var recipes:[Recipe] = [Recipe]()
            print(snapshot) // Its print all values including Snap (User)
            print(snapshot?.value!)
                        
            if let allRecipes   = snapshot?.children.allObjects as? [DataSnapshot] {
                for details in allRecipes {
                    
                    if let recipeDetails = (details.value as? [String: Any]){
                        
                        let userId = recipeDetails["userID"] as? String ?? ""
                        
                        if userId == FirebaseAuthManager.shared.userID {
                            let ingredients = recipeDetails["ingredients"] as? [String: String] ?? [:]
                            recipes.append(Recipe(name: recipeDetails["name"] as? String ?? "", description: recipeDetails["desciption"] as? String ?? "", type: recipeDetails["type"] as? String ?? "", region: recipeDetails["region"] as? String ?? "", thumbUrl: recipeDetails["thumbUrl"] as? String ?? "", videoUrl: recipeDetails["videoUrl"] as? String ?? "", userID: recipeDetails["userID"] as? String ?? "", userName: recipeDetails["userName"] as? String ?? "", userProfileImage: recipeDetails["userProfileImage"] as? String ?? "",duration: recipeDetails["duration"] as? String ?? "",calaroies: recipeDetails["calories"] as? Int ?? 0,ingredients: ingredients, steps: [:]))
                        }
                    }
                    
                }
                complition(recipes)
            }
        }
    }
}
