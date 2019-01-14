//
//  TeamReadOnlyVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/13/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension TeamReadOnlyVC {
    func initUI() {
        self.view.backgroundColor = .black
        initTeamPhoto()
        initTeamName()
        addSlots()
    }

    // UI Initialization Helpers
    func initTeamPhoto() {
        teamPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/4))
        teamPhoto.backgroundColor = .flatBlack
        teamPhoto.contentMode = .scaleAspectFit
        teamPhoto.image = team.img ?? UIImage.avatar_alpha
        teamPhoto.clipsToBounds = true
        view.addSubview(teamPhoto)
        
    }
    
    func initTeamName() {
        teamName = UILabel(frame: LayoutManager.belowCentered(elementAbove: teamPhoto, padding: .PADDING, width: view.frame.width, height: 40))
        teamName.text = team.name
        teamName.textColor = .white
        teamName.font = .SUBTITLE_FONT
        teamName.textAlignment = .center
        teamName.adjustsFontSizeToFitWidth = true
        view.addSubview(teamName)
    }
    
    func addSlots() {
        let startY: CGFloat = teamName.frame.maxY + .PADDING
        let sidePadding: CGFloat = .PADDING * 2
        let intraButtonSpacing: CGFloat = .PADDING * 1.5
        let buttonHeight: CGFloat = view.frame.height/8
        
        for slot in slotsFilled {
            slot.removeFromSuperview()
        }
        slotsFilled = []
        
        for i in 0..<self.slotData.count {
            let frameOfSlot = CGRect(x: sidePadding, y: startY + CGFloat(i) * (intraButtonSpacing + buttonHeight), width: view.frame.width - 2 * sidePadding, height: buttonHeight)
            
            let slotUser = slotData[i]
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
            

            view.addSubview(slot)
            slotsFilled.append(slot)
            
        }
    }
}
