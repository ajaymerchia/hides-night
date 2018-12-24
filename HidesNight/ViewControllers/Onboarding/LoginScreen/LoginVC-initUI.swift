//
//  LoginVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers
import ChameleonFramework

extension LoginVC {
    func initUI() {
        view.backgroundColor = .DARK_BLUE
        
        initGameHeader()
        initTextfields()
        initButtons()
        initGestureRecognizer()
    }
    
    func initGameHeader() {
        logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        logo.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - CGFloat.PADDING*9)
        logo.image = .logo_dark
        
        
        view.addSubview(logo)
        
        
        gameTitle = UILabel(frame: LayoutManager.belowCentered(elementAbove: logo, padding: .PADDING, width: view.frame.width, height: 60))
        gameTitle.textAlignment = .center
        gameTitle.text = "Hides Night"
        gameTitle.font = .TITLE_FONT
        gameTitle.textColor = .white
        view.addSubview(gameTitle)
    }
    
    func initTextfields() {
        usernameField = LabeledTextField(frame: LayoutManager.belowCentered(elementAbove: gameTitle, padding: .PADDING*2, width: view.frame.width - 4 * .PADDING, height: 40))
        
        formatTextfield(tf: usernameField)
        usernameField.placeholder = "Username"
        usernameField.returnKeyType = .next
        usernameField.addTarget(self, action: #selector(advanceToPW), for: .editingDidEndOnExit)
        
        
        
        
        passwordField = LabeledTextField(frame: LayoutManager.belowCentered(elementAbove: usernameField, padding: .PADDING/2, width: usernameField.frame.width, height: usernameField.frame.height))
        
        formatTextfield(tf: passwordField)
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Password"
        passwordField.returnKeyType = .go
        passwordField.addTarget(self, action: #selector(attemptLogin), for: .editingDidEndOnExit)
        
        usernameField.alpha = 0
        passwordField.alpha = 0
        
        view.addSubview(usernameField)
        view.addSubview(passwordField)
    }
    
    func formatTextfield(tf: LabeledTextField) {
        tf.textAlignment = .center
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.font = UIFont.BIG_TEXT_FONT
        
        tf.placeholderColor = .offWhite
        tf.tintColor = .white
        tf.textColor = .white
        
        tf.lineColor = .offWhite
        tf.selectedLineColor = .white
        
        tf.titleColor = .offWhite
        tf.selectedTitleColor = .white
        
        tf.errorColor = .ACCENT_RED
        
        tf.returnKeyType = .next
    }
    
    func initButtons() {
        
        let pixelFontEstimate:CGFloat = 30
        
        howTo = UIButton(frame: CGRect(x: view.frame.width/4, y: view.frame.height - (pixelFontEstimate + .PADDING*1.5), width: view.frame.width/2, height: pixelFontEstimate))
        howTo.setTitle("How to Play", for: .normal)
        howTo.titleLabel?.font = .TEXT_FONT
        howTo.setTitleColor(.white, for: .normal)
        howTo.setTitleColor(.flatWhiteDark, for: .highlighted)
        howTo.addTarget(self, action: #selector(toInstructions), for: .touchUpInside)
        
        
        signUp = UIButton(frame: LayoutManager.aboveCentered(elementBelow: howTo, padding: .MARGINAL_PADDING, width: howTo.frame.width, height: pixelFontEstimate))
        signUp.setTitle("New Here? Sign-Up!", for: .normal)
        signUp.titleLabel?.font = .TEXT_FONT
        signUp.setTitleColor(.white, for: .normal)
        signUp.setTitleColor(.flatWhiteDark, for: .highlighted)
        signUp.addTarget(self, action: #selector(toSignUp), for: .touchUpInside)
        
        
        login = UIButton(frame: LayoutManager.belowCentered(elementAbove: passwordField, padding: .PADDING*2.5, width: view.frame.width/3.5, height: 45))
        login.setTitle("Login", for: .normal)
        login.titleLabel?.font = .SUBTITLE_FONT
        login.setTitleColor(.DARK_BLUE, for: .normal)
        login.setBackgroundColor(color: .white, forState: .normal)
        login.setBackgroundColor(color: .flatWhiteDark, forState: .highlighted)
        login.clipsToBounds = true
        login.layer.cornerRadius = 5
        login.titleEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        login.addTarget(self, action: #selector(attemptLogin), for: .touchUpInside)
        
        
        howTo.alpha = 0
        login.alpha = 0
        signUp.alpha = 0
        
        view.addSubview(howTo)
        view.addSubview(signUp)
        view.addSubview(login)
    }
    
    func initGestureRecognizer() {
        let tapOut = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapOut)
    }
    
    func animateNewComponents() {
        debugPrint("animating")
        UIView.animate(withDuration: 0.75) {
            self.usernameField.alpha = 1
            self.passwordField.alpha = 1

            self.howTo.alpha = 1
            self.login.alpha = 1
            self.signUp.alpha = 1
        }
    }
    
    
    
}
