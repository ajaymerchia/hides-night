//
//  SignUpVC-initUI.swift
//  
//
//  Created by Ajay Merchia on 12/20/18.
//
// initUI

import Foundation
import UIKit
import iosManagers
import SkyFloatingLabelTextField

extension SignUpVC: UITextFieldDelegate {
    func initUI() {
        view.backgroundColor = .black
        initNav()
        initIntroduction()
        initProfilePic()
        initTextfields()
        initSignUp()
        initGestureRecognizer()
    }
    
    // UI Initialization Helpers
    func initNav() {
        if let nav = self.navigationController?.navigationBar {
            nav.tintColor = .white
            nav.backgroundColor = .black
            nav.barTintColor = .black
            
            nav.titleTextAttributes = [NSAttributedString.Key.font: UIFont.HEADER_FONT!, NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.navbar = nav
            
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(goBack))
        
        self.navigationItem.title = "Hides Night"
        
    }
    
    func initIntroduction() {
        signUpPrompt = UILabel(frame: CGRect(x: 0, y: view.frame.height/8, width: view.frame.width, height: 40))
        signUpPrompt.text = "Let's Get You Started"
        signUpPrompt.textColor = .white
        signUpPrompt.font = .SUBTITLE_FONT
        signUpPrompt.textAlignment = .center
        view.addSubview(signUpPrompt)
    }
    
    func initProfilePic() {
        profileSelectButton = UIButton(frame: LayoutManager.belowCentered(elementAbove: signUpPrompt, padding: .PADDING, width: view.frame.width/3.5, height: view.frame.width/3.5))
        
        profileSelectButton.setImage(UIImage.avatar_black, for: .normal)

        profileSelectButton.imageView?.contentMode = .scaleAspectFill
        profileSelectButton.imageView?.layer.cornerRadius = 0.5 * profileSelectButton.frame.width

        profileSelectButton.imageView?.layer.borderWidth = 0.75
        profileSelectButton.imageView?.layer.borderColor = rgba(240,240,240,1).cgColor

        profileSelectButton.addTarget(self, action: #selector(pickProfilePhoto), for: .touchUpInside)

        let label_width: CGFloat = 150
        let label_height: CGFloat = 30
        
        let editPrompt = UILabel(frame: CGRect(x: (profileSelectButton.frame.width - label_width)/2, y: profileSelectButton.frame.height - label_height, width: label_width, height: label_height))
        editPrompt.text = "edit"
        editPrompt.textAlignment = .center
        editPrompt.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        editPrompt.font = UIFont.TEXT_FONT
        editPrompt.textColor = UIColor.ACCENT_BLUE

        profileSelectButton.imageView?.addSubview(editPrompt)

        view.addSubview(profileSelectButton)
    }
    
    func initTextfields() {
        let sideSpacing = view.frame.width/12
        let midSpacing = view.frame.width/15
        let textFieldHeight: CGFloat = 50
        
        
        firstNameTextfield = LabeledTextField(frame: CGRect(x: sideSpacing, y: profileSelectButton.frame.maxY + CGFloat.PADDING, width: (view.frame.width - 2*sideSpacing - midSpacing)/2, height: textFieldHeight))
        firstNameTextfield.placeholder = "First"
        formatTextfield(tf: firstNameTextfield)
        
        
        lastNameTextfield = LabeledTextField(frame: CGRect(x: firstNameTextfield.frame.maxX + midSpacing, y: firstNameTextfield.frame.minY, width: (view.frame.width - 2*sideSpacing - midSpacing)/2, height: textFieldHeight))
        lastNameTextfield.placeholder = "Last"
        formatTextfield(tf: lastNameTextfield)
        
        emailTextfield = LabeledTextField(frame: LayoutManager.belowLeft(elementAbove: firstNameTextfield, padding: .PADDING, width: view.frame.width - 2*sideSpacing, height: textFieldHeight))
        emailTextfield.placeholder = "Email"
        emailTextfield.keyboardType = .emailAddress
        emailTextfield.autocapitalizationType = .none
        formatTextfield(tf: emailTextfield)

        userNameTextfield = LabeledTextField(frame: LayoutManager.belowCentered(elementAbove: emailTextfield, padding: .PADDING, width: emailTextfield.frame.width, height: textFieldHeight))
        userNameTextfield.placeholder = "Username"
        userNameTextfield.autocapitalizationType = .none
        formatTextfield(tf: userNameTextfield)
        
        pw1Textfield = LabeledTextField(frame: LayoutManager.belowCentered(elementAbove: userNameTextfield, padding: .PADDING, width: emailTextfield.frame.width, height: textFieldHeight))
        pw1Textfield.placeholder = "Password"
        pw1Textfield.isSecureTextEntry = true
        pw1Textfield.autocapitalizationType = .none
        formatTextfield(tf: pw1Textfield)
        
        pw2Textfield = LabeledTextField(frame: LayoutManager.belowCentered(elementAbove: pw1Textfield, padding: .PADDING, width: emailTextfield.frame.width, height: textFieldHeight))
        pw2Textfield.placeholder = "Confirm Password"
        pw2Textfield.isSecureTextEntry = true
        pw2Textfield.autocapitalizationType = .none
        formatTextfield(tf: pw2Textfield)
        pw2Textfield.returnKeyType = .join
        
        
        view.addSubview(firstNameTextfield)
        view.addSubview(lastNameTextfield)
        view.addSubview(emailTextfield)
        view.addSubview(userNameTextfield)
        view.addSubview(pw1Textfield)
        view.addSubview(pw2Textfield)
        
    }
    
    func formatTextfield(tf: LabeledTextField) {
        tf.textAlignment = .center
        tf.autocorrectionType = .no
        tf.font = UIFont.BIG_TEXT_FONT
        
        tf.tintColor = .ACCENT_BLUE
        tf.textColor = .ACCENT_BLUE
        
        
        tf.lineColor = .offWhite
        tf.selectedLineColor = .white
        
        tf.titleColor = .offWhite
        tf.selectedTitleColor = .white
        
        tf.errorColor = .ACCENT_RED
        
        tf.returnKeyType = .next
        tf.delegate = self
        
        tf.tag = textFieldTag
        textFieldTag += 1
        
    }
    
    func initSignUp() {
        signUp = UIButton(frame: LayoutManager.belowCentered(elementAbove: pw2Textfield, padding: .PADDING, width: view.frame.width/3, height: 40))
        
        signUp.center = CGPoint(x: view.frame.width/2, y: (view.frame.height + pw2Textfield.frame.maxY)/2)
        
        signUp.setTitle("Join!", for: .normal)
        signUp.setTitleColor(.DARK_BLUE, for: .normal)
        
        signUp.setBackgroundColor(color: .white, forState: .normal)
        signUp.setBackgroundColor(color: .flatWhiteDark, forState: .highlighted)
        
        signUp.titleLabel?.font = .SUBTITLE_FONT
        signUp.clipsToBounds = true
        signUp.layer.cornerRadius = 5
        signUp.titleEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        signUp.addTarget(self, action: #selector(validateFields), for: .touchUpInside)
        
        
        view.addSubview(signUp)
    }
    
    func initGestureRecognizer() {
        let tapOut = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapOut)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        // Try to find next responder
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        if textField.returnKeyType == .join {
            validateFields()
        }
        
        return false
    }


}
