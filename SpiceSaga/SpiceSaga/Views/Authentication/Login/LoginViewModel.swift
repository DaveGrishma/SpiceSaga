//
//  LoginViewModel.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 18/10/23.
//

import Foundation


class LoginViewModel {
    
    func login(email: String, password: String,success: @escaping() -> Void,failure: @escaping() -> Void) {
        FirebaseAuthManager.shared.loginUser(email: email, password: password) {
            success()
        } failure: {
            failure()
        }

    }
}
