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
    func temp() {
        let storageRef = Storage.storage().reference().child("060C1ADB-0744-4FB4-BB77-090DB20C1276.png")
        storageRef.downloadURL { (url, error) in
            print(url)
        }
        
    }
    func uploadImage(name: String,image: Data,completion: @escaping(_ url: String?) -> Void) {
        let name = UUID().uuidString + ".png"
        let storageRef = Storage.storage().reference().child(name)
        storageRef.putData(image, metadata: nil) { (metadata, error) in
            if error != nil {
                print("error")
                completion(nil)
            } else {
                if let path = metadata?.path {
                    completion(path)
                }
                
            }
        }
    }
    
    func uploadVideo(name: String,image: Data,completion: @escaping (_ url: String?) -> Void) {
        let name = UUID().uuidString + ".MOV"
        let storageRef = Storage.storage().reference().child(name)
        storageRef.putData(image, metadata: nil) { (metadata, error) in
            if error != nil {
                print("error")
                completion(nil)
            } else {
                if let videoUrl = metadata?.path {
                    completion(videoUrl)
                }
            }
        }
    }
    
    func getProfilePictureURL(forUserID uid: String, completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference().child("\(uid).png")
        storageRef.downloadURL { (url, error) in
            if let error = error {
                print("Error retrieving profile picture URL: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(url)
            }
        }
    }
}
