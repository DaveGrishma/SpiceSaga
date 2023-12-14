//
//  ValidateClass.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 24/10/23.
//

import Foundation

class ValidateClass {
    
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidUsername(for username: String) -> Bool {
        let username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        return !username.isEmpty
    }
    
    static func isPasswordValid(for password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    static func isValidCountry(for username: String) -> Bool {
        let country = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let countryRegEx = "\\w{4,24}"
        let countryPred = NSPredicate(format: "SELF MATCHES %@", countryRegEx)
        return countryPred.evaluate(with: country)
    }
    
    static func isEmpty(for field: String) -> Bool {
        let checkEmpty = field.trimmingCharacters(in: .whitespacesAndNewlines)
        return checkEmpty.isEmpty
    }
}
