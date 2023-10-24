//
//  FirebaseAuthManager.swift
//  SpiceSaga
//
//  Created by psagc on 19/10/23.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    
    static var shared: FirebaseAuthManager = FirebaseAuthManager()
    func loginUser(email: String, password: String,success: @escaping() -> Void,failure: @escaping() -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if error == nil {
                    print(result?.user.uid)
                    success()
                } else {
                    failure()
                }
            }
        }
    }
    
    func createUserAccount(email: String,password: String,complition: @escaping() -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                complition()
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
}
