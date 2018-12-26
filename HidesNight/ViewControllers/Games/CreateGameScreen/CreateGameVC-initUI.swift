//
//  CreateGameVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension CreateGameVC {
    func initUI() {
        self.view.backgroundColor = .DARK_BLUE
        initNav()
        initScrollview()
        initGameMetadata()
    }

    // UI Initialization Helpers
    func initNav() {
        if let nav = self.navigationController?.navigationBar {
            nav.tintColor = .white
            nav.backgroundColor = .DARK_BLUE
            nav.barTintColor = .DARK_BLUE
            
            nav.titleTextAttributes = [NSAttributedString.Key.font: UIFont.HEADER_FONT!, NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.navbar = nav
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(goBack))
        
        self.navigationItem.title = "Create a Game!"
        
    }
    
    func initScrollview() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: navbar.frame.maxY, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height*2)
        scrollView.indicatorStyle = .white
        scrollView.bounces = true
        view.addSubview(scrollView)
    }
    
    func initGameMetadata() {
        gameNameField = LabeledTextField(frame: CGRect(x: 0, y: .PADDING, width: view.frame.width, height: 60))
        formatTextfield(tf: gameNameField)
        gameNameField.font = .SUBTITLE_FONT
        gameNameField.placeholder = "Game Name"
        gameNameField.text = "\(admin.first!)'s Game"
        gameNameField.becomeFirstResponder()
        scrollView.addSubview(gameNameField)
    }
    
    
    
    func formatTextfield(tf: LabeledTextField) {
        tf.textAlignment = .center
        tf.font = UIFont.BIG_TEXT_FONT
        
        tf.placeholderColor = .offWhite
        tf.tintColor = .white
        tf.textColor = .white
        
        tf.lineColor = .offWhite
        tf.selectedLineColor = .white
        
        tf.titleColor = .offWhite
        tf.selectedTitleColor = .white
        
        tf.errorColor = .ACCENT_RED
        
        tf.returnKeyType = .done
    }

}
