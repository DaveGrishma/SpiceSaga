//
//  FirebaseRMDatabase.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 06/11/23.
//

import FirebaseDatabase
import CoreData

struct Recipe {
    var id: String
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
    
    init(id: String, name: String, description: String, type: String, region: String, thumbUrl: String, videoUrl: String, userID: String, userName: String, userProfileImage: String, duration: String, calaroies: Int, ingredients: [String : String], steps: [String : String]) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.region = region
        self.thumbUrl = thumbUrl
        self.videoUrl = videoUrl
        self.userID = userID
        self.userName = userName
        self.userProfileImage = userProfileImage
        self.duration = duration
        self.calaroies = calaroies
        self.ingredients = ingredients
        self.steps = steps
    }
    
    init(object: NSManagedObject) {
        self.id = object.value(forKey: "id") as? String ?? ""
        self.name = object.value(forKey: "name") as? String ?? ""
        self.description = object.value(forKey: "recipeDesciption") as? String ?? ""
        self.type = object.value(forKey: "type") as? String ?? ""
        self.region = object.value(forKey: "region") as? String ?? ""
        self.thumbUrl = object.value(forKey: "thumbUrl") as? String ?? ""
        self.videoUrl = object.value(forKey: "videoUrl") as? String ?? ""
        self.userID = object.value(forKey: "userID") as? String ?? ""
        self.userName = object.value(forKey: "userName") as? String ?? ""
        self.userProfileImage = object.value(forKey: "userProfileImage") as? String ?? ""
        self.duration = object.value(forKey: "duration") as? String ?? ""
        self.calaroies = object.value(forKey: "calaroies") as? Int ?? 0
        self.ingredients = object.value(forKey: "ingredients") as? [String:String] ?? [:]
        self.steps = object.value(forKey: "steps") as? [String: String] ?? [:]
    }
}
class FirebaseRMDatabase {
    
    static var shared: FirebaseRMDatabase = FirebaseRMDatabase()
    private let rootRef = Database.database()
    private var allRecipes: [Recipe] = [Recipe]()
    
    func getRecipes(complition: @escaping(_ recipes: [Recipe]) -> Void) {
        let recipes = rootRef.reference(withPath: "RecipeApp/Recipes")
        
        recipes.getData { errror, snapshot in
            
            if let allRecipes   = snapshot?.children.allObjects as? [DataSnapshot] {
                self.allRecipes.removeAll()
                for details in allRecipes {
                    
                    if let recipeDetails = (details.value as? [String: Any]){
                        let ingredients = recipeDetails["ingredients"] as? [String: String] ?? [:]
                        let cookingSteps = recipeDetails["steps"] as? [String: String] ?? [:]
                        
                        let recipeDetails = Recipe(id: recipeDetails["id"] as? String ?? "",name: recipeDetails["name"] as? String ?? "", description: recipeDetails["desciption"] as? String ?? "", type: recipeDetails["type"] as? String ?? "", region: recipeDetails["region"] as? String ?? "", thumbUrl: recipeDetails["thumbUrl"] as? String ?? "", videoUrl: recipeDetails["videoUrl"] as? String ?? "", userID: recipeDetails["userID"] as? String ?? "", userName: recipeDetails["userName"] as? String ?? "", userProfileImage: "https://firebasestorage.googleapis.com:443/v0/b/recipeapp-86e78.appspot.com/o/C2C51527-C30C-4E24-A396-44A989309172.png?alt=media&token=b9252216-18a9-41e7-87f5-ef21032b673a",duration: recipeDetails["duration"] as? String ?? "",calaroies: recipeDetails["calories"] as? Int ?? 0,ingredients: ingredients, steps: cookingSteps)
                        
                        self.allRecipes.append(recipeDetails)
                    }
                    
                    
                    
                    
                }
                complition(self.allRecipes.reversed())
            }
        }
        
    }
    
    func addNewRecipe(recipe: Recipe) {
        
        let recipes = rootRef.reference(withPath: "RecipeApp").child("Recipes").childByAutoId()
        
        let newRecipeId = recipes.key ?? ""
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
            "steps": recipe.steps,
            "calories": recipe.calaroies
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
                            recipes.append(Recipe(id: recipeDetails["id"] as? String ?? "",name: recipeDetails["name"] as? String ?? "", description: recipeDetails["desciption"] as? String ?? "", type: recipeDetails["type"] as? String ?? "", region: recipeDetails["region"] as? String ?? "", thumbUrl: recipeDetails["thumbUrl"] as? String ?? "", videoUrl: recipeDetails["videoUrl"] as? String ?? "", userID: recipeDetails["userID"] as? String ?? "", userName: recipeDetails["userName"] as? String ?? "", userProfileImage: recipeDetails["userProfileImage"] as? String ?? "",duration: recipeDetails["duration"] as? String ?? "",calaroies: recipeDetails["calories"] as? Int ?? 0,ingredients: ingredients, steps: [:]))
                        }
                    }
                    
                }
                complition(recipes)
            }
        }
    }
    func deleteRecipe(id: String,complition: @escaping(() -> Void)) {
        let ref = Database.database().reference()
        let nodePath = "RecipeApp/Recipes/\(id)"
        let nodeRef = ref.child(nodePath)
        nodeRef.removeValue { error, _ in
            if let error = error {
                print("Error removing data: \(error.localizedDescription)")
            } else {
                print("Data removed successfully!")
            }
            complition()
        }
    }
    
    func getRecipeDetails(id: String,complition: @escaping(_ recipe: Recipe) -> Void) {
        let recipes = rootRef.reference(withPath: "RecipeApp/Recipes/\(id)")
        recipes.getData { errror, snapshot in
            
            print(snapshot) // Its print all values including Snap (User)
            print(snapshot?.value!)
                        
            if let recipeDetails = (snapshot?.value as? [String: Any]){
                
                let userId = recipeDetails["userID"] as? String ?? ""
                let cookingSteps = recipeDetails["steps"] as? [String: String] ?? [:]

                let ingredients = recipeDetails["ingredients"] as? [String: String] ?? [:]
                let recipeDetails: Recipe = Recipe(id: recipeDetails["id"] as? String ?? "",name: recipeDetails["name"] as? String ?? "", description: recipeDetails["desciption"] as? String ?? "", type: recipeDetails["type"] as? String ?? "", region: recipeDetails["region"] as? String ?? "", thumbUrl: recipeDetails["thumbUrl"] as? String ?? "", videoUrl: recipeDetails["videoUrl"] as? String ?? "", userID: userId, userName: recipeDetails["userName"] as? String ?? "", userProfileImage: recipeDetails["userProfileImage"] as? String ?? "",duration: recipeDetails["duration"] as? String ?? "",calaroies: recipeDetails["calories"] as? Int ?? 0,ingredients: ingredients, steps: cookingSteps)
                complition(recipeDetails)
            }
        }
    }
    
    func updateusernameForRecipes(userId: String,name: String) {
        let myRecipes = self.allRecipes.filter({$0.userID == userId})
        var updateName: [String: String] = [:]
        
        for recipe in myRecipes {
            updateName["RecipeApp/Recipes/\(recipe.id)/userName"] = name
        }
        rootRef.reference().updateChildValues(updateName)
    }
    
    var numberOfRecipes: Int {
        return allRecipes.filter({$0.userID == FirebaseAuthManager.shared.userID}).count
    }
}
