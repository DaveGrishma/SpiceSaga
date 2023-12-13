//
//  FirebaseAuthManager.swift
//  SpiceSaga
//
//  Created by psagc on 19/10/23.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


struct UserDetails {
    var userId: String
    var userName: String
    var profileUrl: String
}

class FirebaseAuthManager {
    
    static var shared: FirebaseAuthManager = FirebaseAuthManager()
    
    var currentUser: UserDetails?
    
    func loginUser(email: String, password: String,success: @escaping() -> Void,failure: @escaping() -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if error == nil {
                    success()
                } else {
                    failure()
                }
            }
        }
        
    }
    
    func setUpUserDetails() {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("RecipeApp").child("Users").child(uid)
            
            ref.observeSingleEvent(of: .value) { (snapshot, error)  in
                if let userData = snapshot.value as? [String: Any] {
                    let name = userData["name"] as? String ?? ""
                    let profileImageUrl = userData["profileImageUrl"] as? String ?? ""
                    let userDetails = UserDetails(userId: uid, userName: name, profileUrl: profileImageUrl)
                    self.currentUser = userDetails
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
            
            guard let uid = authResult?.user.uid else {
                completion(NSError(domain: "User registration failed", code: 0, userInfo: nil))
                return
            }
            
            // Upload the profile image to Firebase Storage
            let storageRef = Storage.storage().reference().child("\(uid).png")
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
                        
                        if let profileImageUrl = url?.absoluteString {
                            let userData = ["name": name, "profileImageUrl": profileImageUrl,"country": country]
                            let ref = Database.database().reference().child("RecipeApp").child("Users").child(uid)
                            ref.setValue(userData)
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
    
    
}
