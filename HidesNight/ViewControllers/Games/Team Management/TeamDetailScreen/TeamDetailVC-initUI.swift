//
//  TeamDetailVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/28/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension TeamDetailVC: UITextFieldDelegate {
    func initUI() {
        self.view.backgroundColor = .black
        initNav()
        initPhotopicker()
        initTextfield()
        addSlots()
    }

    // UI Initialization Helpers
    func initNav() {
        self.title = team.name
        
        
        if hasPermissions {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishEditingTeam))
            
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor : rgb(162,162,162)], for: .disabled)
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor : UIColor.ACCENT_BLUE], for: .normal)
            setBarButton(valid: false)
        }
        
    }
    
    func initPhotopicker() {
        teamPhoto = UIButton(frame: CGRect(x: .PADDING, y: .PADDING, width: view.frame.width/6, height: view.frame.width/6))
        
        if let img = team.img {
            teamPhoto.setImage(img, for: .normal)
            teamPhoto.imageView?.contentMode = .scaleAspectFill
            teamPhoto.imageEdgeInsets = .zero
        } else {
            teamPhoto.setImage(UIImage.nav_add_image.withRenderingMode(.alwaysTemplate), for: .normal)
            teamPhoto.imageView?.tintColor = .white
            teamPhoto.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            teamPhoto.imageView?.contentMode = .scaleAspectFit
        }
        
        
        
        teamPhoto.layer.cornerRadius = 0.5 * teamPhoto.frame.width
        teamPhoto.layer.borderWidth = 0.75
        teamPhoto.layer.borderColor = rgba(240,240,240,1).cgColor
        teamPhoto.clipsToBounds = true
        
        if hasPermissions {
            teamPhoto.addTarget(self, action: #selector(pickProfilePhoto), for: .touchUpInside)
        }
        
        view.addSubview(teamPhoto)
    }
    
    func initTextfield() {
        teamName = LabeledTextField(frame: CGRect(x: teamPhoto.frame.maxX + .PADDING, y: teamPhoto.frame.minY, width: view.frame.width - (.PADDING + teamPhoto.frame.maxX + .PADDING), height: teamPhoto.frame.height))
        view.addSubview(teamName)
        
        teamName.placeholder = "Team Name"
        teamName.placeholderColor = rgba(162,162,162,1)
        teamName.placeholderFont = UIFont.SUBTITLE_FONT
        
        teamName.text = team.name
        teamName.textColor = .white
        teamName.font = UIFont.SUBTITLE_FONT
        
        teamName.selectedLineColor = .ACCENT_BLUE
        teamName.selectedTitleColor = .ACCENT_BLUE
        
        teamName.titleFont = UIFont.TEXT_FONT!.bold
        teamName.titleColor = rgba(162,162,162,1)
        teamName.returnKeyType = .continue
        
        teamName.errorColor = .ACCENT_RED
        
        teamName.addTarget(self, action: #selector(changeTitle), for: .editingChanged)
        teamName.addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
        teamName.additionalDistance = 0
        teamName.keyboardToolbar.isHidden = true
        teamName.autocorrectionType = .yes
        
        teamName.isUserInteractionEnabled = hasPermissions
        
    }
    
    func addSlots() {
        let startY: CGFloat = teamName.frame.maxY + .PADDING * 3
        let sidePadding: CGFloat = .PADDING * 2
        let intraButtonSpacing: CGFloat = .PADDING * 1.5
        let buttonHeight: CGFloat = view.frame.height/7
        
        for button in slots {
            button.removeFromSuperview()
        }
        slots = []
        
        for slot in slotsFilled {
            slot.removeFromSuperview()
        }
        slotsFilled = []
        
        for i in 0..<3 {
            let frameOfSlot = CGRect(x: sidePadding, y: startY + CGFloat(i) * (intraButtonSpacing + buttonHeight), width: view.frame.width - 2 * sidePadding, height: buttonHeight)
            
            if let slotUser = slotData[i] {
                let slot = UIView(frame: frameOfSlot)
                slot.tag = i
                
                let border = UIView(frame: CGRect(x: 0, y: 0, width: frameOfSlot.width, height: frameOfSlot.height))
                
                border.layer.cornerRadius = 5
                border.layer.borderColor = UIColor.white.cgColor
                border.layer.borderWidth = 0.75
                slot.addSubview(border)
                
                let imgview = UIImageView(frame: CGRect(x: .PADDING, y: 0, width: slot.frame.height - .PADDING, height: slot.frame.height - .PADDING))
                imgview.center = CGPoint(x: imgview.frame.midX, y: slot.frame.height/2)
                imgview.contentMode = .scaleAspectFill
                imgview.clipsToBounds = true
                imgview.image = slotUser.profilePic ?? .avatar_black
                imgview.layer.cornerRadius = imgview.frame.width/2
                
                slot.addSubview(imgview)
                
                let nameOfUser = UILabel(frame: CGRect(x: imgview.frame.maxX + .PADDING, y: 0, width: slot.frame.width - (imgview.frame.maxX + 2 * .PADDING), height: 30))
                nameOfUser.center = CGPoint(x: nameOfUser.frame.midX, y: slot.frame.height/2 + 5)
                nameOfUser.adjustsFontSizeToFitWidth = true
                nameOfUser.font = .SUBTITLE_FONT
                nameOfUser.textColor = .white
                nameOfUser.text = slotUser.fullname
                slot.addSubview(nameOfUser)
                
                let buttonDiameter: CGFloat = 40
                let removeUser = UIButton(frame: CGRect(x: slot.frame.width - buttonDiameter/2, y: 10-buttonDiameter/2, width: buttonDiameter, height: buttonDiameter))
                removeUser.setBackgroundColor(color: .ACCENT_RED, forState: .normal)
                removeUser.setTitle("X", for: .normal)
                removeUser.setTitleColor(.white, for: .normal)
                removeUser.titleLabel?.font = .HEADER_FONT
                removeUser.layer.cornerRadius = removeUser.frame.width/2
                removeUser.clipsToBounds = true
                removeUser.tag = i
                
                if isTeamDictator || (isTeamManager && slotUser == self.user) {
                    removeUser.addTarget(self, action: #selector(removePlayer), for: .touchUpInside)
                    slot.addSubview(removeUser)
                }
                
                
                
                view.addSubview(slot)
                slotsFilled.append(slot)
                
            } else {
                let button = UIButton(frame: frameOfSlot)
                button.tag = i
                button.setBackgroundColor(color: .black, forState: .normal)
                button.setBackgroundColor(color: .flatBlackDark, forState: .highlighted)
                
                button.titleLabel?.font = .HEADER_FONT
                button.layer.cornerRadius = 5
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.borderWidth = 0.75
                button.clipsToBounds = true
                
                view.addSubview(button)
                
                if isTeamDictator {
                    button.setTitle("Add Team Member", for: .normal)
                    button.addTarget(self, action: #selector(goToMemberSelect(_:)), for: .touchUpInside)
                } else if isTeamManager && !slotData.contains(self.user) {
                    button.setTitle("Join This Team", for: .normal)
                    button.addTarget(self, action: #selector(addSelfToTeam(_:)), for: .touchUpInside)
                } else {
                    button.removeFromSuperview()
                }
                
                slots.append(button)
            }
        }
        
    }
    
    
    
    
    
    
    @objc func changeTitle() {
        self.title = teamName.text
        
        if teamName.text == "" {
            teamName.errorMessage = "Team Name can't be Blank"
        } else {
            teamName.errorMessage = ""
        }
        validateTeam()
        
    }
    @objc func dismissKeyboard() {
        teamName.resignFirstResponder()
        
    }

}
