//
//  FirebaseAuthManager.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 19/10/23.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


struct UserDetails : Codable {
    var userId: String
    var userName: String
    var profileUrl: String
    var country: String
    var email: String
}

class FirebaseAuthManager {
    
    static var shared: FirebaseAuthManager = FirebaseAuthManager()
    
    var currentUser: UserDetails?
    
    init() {
        if let userData = UserDefaults.standard.value(forKey: "user") as? Data, let user = try? JSONDecoder().decode(UserDetails.self, from: userData) {
            currentUser = user
        }
    }
    func loginUser(email: String, password: String,success: @escaping() -> Void,failure: @escaping() -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if error == nil {
                    self.getUserDetails {
                        success()
                    }
                } else {
                    failure()
                }
            }
        }
        
    }
    
    func setUpUserDetails() {
        if let user = Auth.auth().currentUser {
            let ref = Database.database().reference().child("RecipeApp").child("Users").child(user.uid)
            ref.observeSingleEvent(of: .value) { (snapshot, error)  in
                if let userData = snapshot.value as? [String: Any] {
                    let name = userData["name"] as? String ?? ""
                    let profileImageUrl = userData["profileImageUrl"] as? String ?? ""
                    let countryName = userData["country"] as? String ?? ""
                    let userDetails = UserDetails(userId: user.uid, userName: name, profileUrl: profileImageUrl, country: countryName, email: user.email ?? "")
                    self.currentUser = userDetails
                    self.saveUserDetails()
                }
            }
        }
    }
    func createUserAccount(email: String, password: String, name: String,country: String, profileImage: UIImage, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let user = authResult?.user else {
                completion(NSError(domain: "User registration failed", code: 0, userInfo: nil))
                return
            }
            let profileImageName: String = "\(user.uid).png"
            // Upload the profile image to Firebase Storage
            let storageRef = Storage.storage().reference().child(profileImageName)
            if let imageData = profileImage.jpegData(compressionQuality: 0.5) {
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            completion(error)
                            return
                        }
                        
                        if let _ = url?.absoluteString {
                            let userData = ["name": name, "profileImageUrl": profileImageName,"country": country]
                            let ref = Database.database().reference().child("RecipeApp").child("Users").child(user.uid)
                            ref.setValue(userData)
                            let userDetails = UserDetails(userId: user.uid, userName: name, profileUrl: profileImageName, country: country, email: user.email ?? "")
                            self.currentUser = userDetails
                            self.saveUserDetails()
                            completion(nil)
                        } else {
                            completion(NSError(domain: "Profile image URL is nil", code: 0, userInfo: nil))
                        }
                    }
                }
            } else {
                completion(NSError(domain: "Image conversion failed", code: 0, userInfo: nil))
            }
        }
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var userID: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    var userDetails: User? {
        Auth.auth().currentUser
    }
    
    func updateProfilePicture(profileImage: UIImage,name: String,country: String, completion: @escaping((_ error: Error?) -> Void)) {
        let profileImageName: String = "\(userID).png"
        let storageRef = Storage.storage().reference().child(profileImageName)
        if let imageData = profileImage.jpegData(compressionQuality: 0.5) {
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    self.updateUserDetails(name: name, country: country) {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func updateUserDetails(name: String,country: String,completion: @escaping(() -> Void)) {
        let userData = ["name": name,"country": country]
        let ref = Database.database().reference().child("RecipeApp").child("Users").child(self.userID)
        ref.setValue(userData)
        currentUser?.userName = name
        currentUser?.country = country
        FirebaseRMDatabase.shared.updateusernameForRecipes(userId: userID, name: name)
        saveUserDetails()
        completion()
    }
    
    func getUserDetails(complition: @escaping(() -> ())) {
        if let user = Auth.auth().currentUser {
            let ref = Database.database().reference().child("RecipeApp").child("Users").child(user.uid)
            ref.getData { error, snapshot in
                if let userData = snapshot?.value as? [String: Any] {
                    let name = userData["name"] as? String ?? ""
                    let profileImageUrl = userData["profileImageUrl"] as? String ?? ""
                    let countryName = userData["country"] as? String ?? ""
                    let userDetails = UserDetails(userId: user.uid, userName: name, profileUrl: profileImageUrl, country: countryName, email: user.email ?? "")
                    self.currentUser = userDetails
                    self.saveUserDetails()
                }
                complition()
            }
        }
    }
    
    private func saveUserDetails() {
        if let user = self.currentUser, let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.setValue(userData, forKey: "user")
            UserDefaults.standard.synchronize()
        }
    }
}
