//
//  FirebaseRealTimeStorage.swift
//  SpiceSaga
//
//  Created by psagc on 19/10/23.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FirebaseRealTimeStorage {
    
    static var shared: FirebaseRealTimeStorage = FirebaseRealTimeStorage()
    
    
    
    func setProfile(name: String,country: String) {
        var ref: DatabaseReference!

        ref = Database.database().reference()
        ref.child("RecipeApp/Users/\(Auth.auth().currentUser?.uid ?? "")/name").setValue(name)
        ref.child("RecipeApp/Users/\(Auth.auth().currentUser?.uid ?? "")/country").setValue(country)
    }
    
    func uploadMedia(name: String,country: String,image: Data,completion: @escaping (_ url: String?) -> Void) {

        let storageRef = Storage.storage().reference().child("\(Auth.auth().currentUser?.uid ?? "").png")
        storageRef.putData(image, metadata: nil) { (metadata, error) in
            if error != nil {
                print("error")
                completion(nil)
            } else {
                self.setProfile(name: name, country: country)
            }
        }
    }
}
