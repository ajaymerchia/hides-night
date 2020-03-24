//
//  TeamDetailVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/28/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension TeamDetailVC {
    @objc func pickProfilePhoto() {
        let actionSheet = UIAlertController(title: "Select Photo From", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = teamPhoto
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.present(actionSheet, animated: true)
    }
    
    func grabData() {
        if indexSelected != nil {
            self.slotData[indexSelected] = self.selectionVC.slots[indexSelected]
            self.selectionVC = nil
            self.indexSelected = nil
        }
    }
    
    @objc func addSelfToTeam(_ sender: UIButton) {
        self.slotData[sender.tag] = self.user
        setBarButton(valid: true)
        addSlots()
    }
    
    func loadData() {
        slotData = team.getMembersOfTeamFrom(game: self.game)
        
        while slotData.count < 3 {
            slotData.append(nil)
        }
        
    }
    
    
    func validateTeam(attempt: Bool = false) -> Bool {
       
        if teamName.text == "" {
            setBarButton(valid: false)
            return false
        }
        
        if slotData.filter({ (usr) -> Bool in return usr != nil}).count == 0 {
            setBarButton(valid: false)
            
            if attempt {
                for slotSelector in slots {
                    slotSelector.shake()
                }
            }
            
            
            return false
        }
        
        setBarButton(valid: true)
        return true
        
    }
    
    func setBarButton(valid: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = valid
    }
    
    @objc func finishEditingTeam() {
        if !validateTeam(attempt: true) {
            return
        }
        
        alerts.startProgressHud(withMsg: "Creating Team", style: .dark)
        
        
        for user in self.slotData {
            if let toAdd = user {
                self.team.addMember(user: toAdd)
            }
        }
        team.name = teamName.text
        let newImage = teamPhoto.imageView?.image
        team.img = photoChanged ? newImage : team.img
        
        self.game.teams[team.uid] = team
        
        
        FirebaseAPIClient.updateRemoteGame(game: self.game, success: {
            if self.photoChanged {
                FirebaseAPIClient.updatePhoto(forTeam: self.team, inGame: self.game, completion: {
                    self.alerts.triggerCallback()
                })
            } else {
                self.alerts.triggerCallback()
            }
            
        }) {
            self.alerts.triggerCallback()
        }
    }
    
    @objc func removePlayer(_ sender: UIButton) {
        self.team.memberIDs.removeValue(forKey: self.slotData[sender.tag]?.uid ?? "")
        self.slotData[sender.tag] = nil
        addSlots()
        _ = validateTeam()
        
    }


}
