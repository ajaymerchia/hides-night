//
//  ProfileVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/23/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension ProfileVC {
    func initUI() {
        resetBounds()
        initProfileImg()
        initLabels()
        initButtons()
    }

    // UI Initialization Helpers
    func resetBounds() {
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.625, height: view.frame.height))
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.flatBlackDark()
    }
    
    
    func initProfileImg() {
        profileImg = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.width/2))
        profileImg.center = CGPoint(x: view.frame.width/2, y: view.frame.height/5)
        
        var labelTitle = "edit"
        var img: UIImage = .avatar_black
        if let newImg = user.profilePic {
            img = newImg
            labelTitle = "update"
        }
        
        profileImg.setImage(img, for: .normal)
        
        profileImg.imageView?.contentMode = .scaleAspectFill
        profileImg.imageView?.layer.cornerRadius = 0.5 * profileImg.frame.width
        
        profileImg.imageView?.layer.borderWidth = 1.5
        profileImg.imageView?.layer.borderColor = rgba(240,240,240,1).cgColor
        
        profileImg.addTarget(self, action: #selector(pickProfilePhoto), for: .touchUpInside)
        
        let label_width: CGFloat = 150
        let label_height: CGFloat = 30
        
        let editPrompt = UILabel(frame: CGRect(x: (profileImg.frame.width - label_width)/2, y: profileImg.frame.height - label_height, width: label_width, height: label_height))
        editPrompt.text = labelTitle
        editPrompt.textAlignment = .center
        editPrompt.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        editPrompt.font = UIFont.TEXT_FONT
        editPrompt.textColor = UIColor.white
        
        profileImg.imageView?.addSubview(editPrompt)
        
        view.addSubview(profileImg)
    }
    
    func initLabels() {
        name = UILabel(frame: LayoutManager.belowCentered(elementAbove: profileImg, padding: .PADDING, width: view.frame.width-40, height: 40))
        name.textAlignment = .center
        name.font = .SUBTITLE_FONT
        name.textColor = .white
        name.text = user.fullname
        name.adjustsFontSizeToFitWidth = true
        
        view.addSubview(name)
        view.addSubview(UISuite.getBorder(forView: name, thickness: 1.5, color: .white, side: .Bottom))
        
    }
    
    func initButtons() {
        
        let insets:CGFloat = 20
        
        let helpTemplateImage = UIImage.nav_info.withRenderingMode(.alwaysTemplate)
        let helpPreferredColor: UIColor = .flatWhite()
        
        helpButton = UIButton(frame: LayoutManager.belowCentered(elementAbove: name, padding: .PADDING*2, width: view.frame.width/3, height: view.frame.width/3))
        helpButton.setImage(helpTemplateImage, for: .normal)
        helpButton.tintColor = helpPreferredColor

        helpButton.imageView?.contentMode = .scaleAspectFill
        helpButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        helpButton.layer.cornerRadius = 0.5 * helpButton.frame.width
        helpButton.layer.borderWidth = 1.5
        helpButton.layer.borderColor = helpPreferredColor.cgColor
        
        helpButton.addTarget(self, action: #selector(toInstructions), for: .touchUpInside)
        view.addSubview(helpButton)
        
        helpText = UILabel(frame: LayoutManager.belowCentered(elementAbove: helpButton, padding: .MARGINAL_PADDING, width: view.frame.width-40, height: 40))
        helpText.textAlignment = .center
        helpText.font = .HEADER_FONT
        helpText.textColor = .white
        helpText.text = "How to Play"
        helpText.adjustsFontSizeToFitWidth = true
        view.addSubview(helpText)
        
        
        let logoutTemplateImage = UIImage.nav_logout.withRenderingMode(.alwaysTemplate)
        
        let logoutPreferredColor: UIColor = .ACCENT_RED
        
        logoutButton = UIButton(frame: LayoutManager.belowCentered(elementAbove: helpText, padding: .PADDING*2, width: view.frame.width/3, height: view.frame.width/3))
        logoutButton.setImage(logoutTemplateImage, for: .normal)
        logoutButton.tintColor = logoutPreferredColor
        
        logoutButton.imageView?.contentMode = .scaleAspectFill
        logoutButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        logoutButton.layer.cornerRadius = 0.5 * logoutButton.frame.width
        logoutButton.layer.borderWidth = 1.5
        logoutButton.layer.borderColor = logoutPreferredColor.cgColor
        
        logoutButton.addTarget(self, action: #selector(performLogout), for: .touchUpInside)
        view.addSubview(logoutButton)
        
        logoutText = UILabel(frame: LayoutManager.belowCentered(elementAbove: logoutButton, padding: .MARGINAL_PADDING, width: view.frame.width-40, height: 40))
        logoutText.textAlignment = .center
        logoutText.font = .HEADER_FONT
        logoutText.textColor = .ACCENT_RED
        logoutText.text = "Logout"
        logoutText.adjustsFontSizeToFitWidth = true
        view.addSubview(logoutText)
        
        
    }

}
