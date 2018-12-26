//
//  SignUpVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers
extension SignUpVC {
    func loadRestrictedAccounts() {
        restrictedUsernames = ["admin"]
        restrictedEmails = ["admin@admin.com"]
        
        FirebaseAPIClient.getAllAccounts { (accounts) in
            for (key, value) in accounts {
                self.restrictedUsernames.append(key)
                self.restrictedUsernames.append(value)
            }
        }
        
    }
    
    @objc func pickProfilePhoto() {
        let actionSheet = UIAlertController(title: "Select Photo From", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = profileSelectButton
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.present(actionSheet, animated: true)
    }
    
    func signupError(code: SignupError) {
        var msg = "We had an issue with "
        
        switch code {
        case .NameBlank:
            msg = msg + "your name."
            firstNameTextfield.shake()
            lastNameTextfield.shake()
        case .EmailBlank:
            msg = msg + "your email address."
            emailTextfield.shake()
        case .UsernameBlank:
            msg = msg + "your username."
            userNameTextfield.shake()
        case .PasswordTooShort:
            msg = "Please make sure your password is at least 8 characters long."
            pw1Textfield.shake()
            pw2Textfield.shake()
        case .PasswordMatchFail:
            msg = "Your passwords don't match."
            pw1Textfield.shake()
            pw2Textfield.shake()
        case .UsernameInUse:
            msg = "Sorry! That username is already taken."
            userNameTextfield.shake()
        case .EmailInUse:
            msg = "That email is already in use. Forgot your password? Contact Support!"
        case .EmailInvalid:
            msg = "Make sure your email is correct"
        case .FirebaseSignupError:
            msg = msg + "something. Try again later."
        }
        
        alerts.displayAlert(title: "Oops!", message: msg)
        
    }
    
    @objc func validateFields() {
        self.view.isUserInteractionEnabled = false
        hud = alerts.startProgressHud(withMsg: "Creating Account", style: .dark)
        
        if let emailError = emailValidator() {
            signupError(code: emailError)
            return
        }
        if let userError = usernameValidator() {
            signupError(code: userError)
            return
        }
        if let pw1Error = pw1Validator() {
            signupError(code: pw1Error)
            return
        }
        if let pw2Error = pw2Validator() {
            signupError(code: pw2Error)
            return
        }
        
        guard let firstName = firstNameTextfield.getText() else {
            signupError(code: .NameBlank)
            return
        }
        guard let lastName = lastNameTextfield.getText() else {
            signupError(code: .NameBlank)
            return
        }
        guard let email = emailTextfield.getText() else {
            signupError(code: .EmailBlank)
            return
        }
        guard let username = userNameTextfield.getText() else {
            signupError(code: .UsernameBlank)
            return
        }
        guard let pw = pw1Textfield.getText() else {
            signupError(code: .PasswordTooShort)
            return
        }
        
        var profilePic: UIImage? = nil
        
        if let img = profileSelectButton.imageView?.image {
            if img != UIImage.avatar_black {
                profilePic = img
            }
        }
                
        createAccount(firstName, lastName, email, username, pw, picture: profilePic)
    }
    
    func createAccount(_ first: String, _ last: String, _ email: String, _ username: String, _ pw: String, picture: UIImage?) {
        FirebaseAPIClient.createAccount(withEmail: email, andPassword: pw, success: { (user) in
            
            // Account Created,
            let usr = User(uid: user.user.uid, first: first, last: last, email: email, username: username)
            
            if let img = picture {
                usr.setProfilePicture(to: img, updateRemote: false)
            }
            
            debugPrint("Creating user account for ")
            debugPrint(usr)
            FirebaseAPIClient.uploadUser(usr: usr, withPhoto: (picture != nil), completion: {
                
                let dataToPost = ["user": usr]
                NotificationCenter.default.post(name: .hasPendingUserLogin, object: nil, userInfo: dataToPost as [AnyHashable : Any])
                self.dismiss(animated: true, completion: {})
                
            }, fail: {
                self.signupError(code: .FirebaseSignupError)
            })
        }) {
            self.signupError(code: .FirebaseSignupError)
        }
    }
    
    
}
