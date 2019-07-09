//
//  UserFieldValidator.swift
//  MathPortal
//
//  Created by Petra Čačkov on 17/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class FieldValidator {
    let username: String?
    let email: String?
    let age: String?
    
    var usernameValidated: Bool = true
    var emailValidated: Bool = true
    var ageValidated: Bool = true
    
    init(validate fields: [Field], username: String? = nil, email: String? = nil, age: String? = nil) {
        for field in fields {
            switch field {
            case .username: usernameValidated = false
            case .email: emailValidated = false
            case .age: ageValidated = false
            }
        }
        self.username = username
        self.email = email
        self.age = age
    }
    
    enum Field {
        case username
        case email
        case age
    }
    
    enum Result {
        case OK
        case usernameAlreadyTaken
        case emailAlreadyTaken
        case emailInvalid
        case ageInvalid
        
        var error: String {
            switch self {
            case .usernameAlreadyTaken: return "Uername is already taken"
            case .emailAlreadyTaken: return "Email is already taken"
            case .emailInvalid: return "Email is not the right format"
            case .ageInvalid: return "Age is not valid"
            case .OK: return "Evrything fine"
            }
        }
    }
    
    private var nameValid: Bool = true { didSet { checkValid() } }
    private var emailValid: Bool = true { didSet { checkValid() } }
    private var emailTaken: Bool = false { didSet { checkValid() } }
    private var ageValid: Bool = true { didSet { checkValid() } }
    private var completion: ((_ result: Result) -> Void)?
    
    private var selfReference: FieldValidator?
    
    func validate(_ completion: @escaping (_ result: Result) -> Void) {
        self.completion = completion
        selfReference = self
        if let username = username, username.count > 0 {
            User.usernameIsAlreadyTaken(username: username) { (taken, error)  in
                if let taken = taken {
                    self.usernameValidated = true
                    self.nameValid = !taken
                }
            }
        }
        if let email = email, email.count > 0 {
            User.emailIsAlreadyTaken(email: email) { (taken, error)  in
                
                if let taken = taken {
                    self.emailTaken = taken
                }
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                
                self.emailValidated = true // has to be placet before the last email validation
                self.emailValid = emailTest.evaluate(with: email)
            }
        } 
        
        if let age = age, age.count > 0, Int(age) == nil {
            self.ageValidated = true
            self.ageValid = false
        } else if let age = age, let ageAsInt = Int(age) , ageAsInt < 0 {
            self.ageValidated = true
            self.ageValid = false
        } else {
            self.ageValidated = true
            ageValid = true
        }
    }
    
    private func allChecked() -> Bool {
        guard usernameValidated, emailValidated, ageValidated else { return false }
        return true
    }
    
    private func checkValid() {
        guard allChecked() else { return }
        if !nameValid { completion?(.usernameAlreadyTaken) }
        else if !emailValid { completion?(.emailInvalid) }
        else if emailTaken { completion?(.emailAlreadyTaken)}
        else if !ageValid { completion?(.ageInvalid)}
        else { completion?(.OK) }
        
        completion = nil
        selfReference = nil
    }
    
}

