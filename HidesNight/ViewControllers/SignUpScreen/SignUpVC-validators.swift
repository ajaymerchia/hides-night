//
//  SignUpVC-validators.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/21/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit

extension SignUpVC {
    func addValidators() {
        emailTextfield.addTarget(self, action: #selector(emailValidatorProxy), for: .editingChanged)
        userNameTextfield.addTarget(self, action: #selector(usernameValidatorProxy), for: .editingChanged)
        pw1Textfield.addTarget(self, action: #selector(pw1ValidatorProxy), for: .editingChanged)
        pw2Textfield.addTarget(self, action: #selector(pw2ValidatorProxy), for: .editingChanged)
    }
    
    @objc func emailValidatorProxy() { _ = emailValidator() }
    @objc func usernameValidatorProxy() { _ = usernameValidator() }
    @objc func pw1ValidatorProxy() { _ = pw1Validator() }
    @objc func pw2ValidatorProxy() { _ = pw2Validator() }
    
    
    func emailValidator() -> SignupError? {
        guard let text = emailTextfield.text else {
            emailTextfield.errorMessage = ""
            return .EmailBlank
        }
        if text == "" {
            emailTextfield.errorMessage = ""
            return .EmailBlank
        } else if !text.contains("@") || !text.contains(".") || text.count < 3 {
            emailTextfield.errorMessage = "Invalid Email"
            return .EmailInvalid
        } else if restrictedEmails.contains(text.lowercased()) {
            emailTextfield.errorMessage = "Account Already Exists"
            return .EmailInUse
        }
        
        emailTextfield.errorMessage = ""
        return nil
    }
    
    func usernameValidator() -> SignupError? {
        guard let text = userNameTextfield.text else {
            userNameTextfield.errorMessage = ""
            return .UsernameBlank
        }
        if text == "" {
            userNameTextfield.errorMessage = ""
            return .UsernameBlank
        } else if restrictedUsernames.contains(text.lowercased()) {
            userNameTextfield.errorMessage = "Username Taken!"
            return .UsernameInUse
        }
    
        userNameTextfield.errorMessage = ""
        return nil
        
    }
    
    func pw1Validator() -> SignupError? {
        guard let text = pw1Textfield.text else {
            pw1Textfield.errorMessage = ""
            return .PasswordTooShort
        }
        if text == "" {
            pw1Textfield.errorMessage = ""
            return .PasswordTooShort
        } else if text.count < 8 {
            pw1Textfield.errorMessage = "Password Must Be 8 Characters"
            return .PasswordTooShort
        }
        
        pw1Textfield.errorMessage = ""
        return nil
    }
    
    func pw2Validator() -> SignupError? {
        guard let text = pw1Textfield.text else {
            return .PasswordTooShort
        }
        
        guard let text2 = pw2Textfield.text else {
            pw2Textfield.errorMessage = ""
            return .PasswordMatchFail
        }
        
        if text2 == "" {
            pw2Textfield.errorMessage = ""
            return .PasswordMatchFail
        } else if text != text2 {
            pw2Textfield.errorMessage = "Password Don't Match"
            return .PasswordMatchFail
        }
        
        pw2Textfield.errorMessage = ""
        return nil
        
        
    }
}
