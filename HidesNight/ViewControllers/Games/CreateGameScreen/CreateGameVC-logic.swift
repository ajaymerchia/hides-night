//
//  CreateGameVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension CreateGameVC {
    func getData() {
        self.admin = (self.navigationController as! DataNavVC).user
        
        if (self.navigationController as! DataNavVC).game != nil {
            self.game = (self.navigationController as! DataNavVC).game
            editMode = true
        }
        
    }
    
    @objc func requestEventImage() {
        let actionSheet = UIAlertController(title: "Select Event Photo From", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .photoLibrary)
        }))
        
        if self.eventImageHeader.image != nil {
            actionSheet.addAction(UIAlertAction(title: "Remove Current Photo", style: .destructive, handler: { (action) -> Void in
                // Animate the Top UIView away
                self.removeEventPhoto()
            }))
        }
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = addImageButton
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.present(actionSheet, animated: true)
    }
    
    func animateInHeader(img: UIImage) {
        UIView.animate(withDuration: 1) {
            self.tableview.beginUpdates()
            self.eventImageHeader.image = img
            self.tableview.tableHeaderView = self.eventImageHeader
            self.tableview.endUpdates()
        }
    }
    
    func removeEventPhoto() {
        UIView.animate(withDuration: 1) {
            self.tableview.beginUpdates()
            self.eventImageHeader.image = nil
            self.tableview.tableHeaderView = nil
            self.tableview.endUpdates()
        }
    }
    
    func ind(_ section: Int, _ row: Int) -> IndexPath {
        return IndexPath(item: row, section: section)
    }
    
    func update(label: UILabel, withInterval: TimeInterval) {
        label.text = myUtils.getFormattedCountdown(interval: withInterval)
    }
    
    func activate(cell: UITableViewCell, index: IndexPath) {
        durationPickers[index.row].alpha = 1
        
        switch index.row {
        case 1:
            for borders in allBorders {
                borders[0].alpha = 0
                borders[1].alpha = 0
            }
            allBorders[0][1].alpha = 1
            allBorders[2][0].alpha = 1
            
        case 2:
            // make all bottom visible
            for borders in allBorders {
                borders[0].alpha = 0
                borders[1].alpha = 1
            }
        default:
            // make all top visible
            for borders in allBorders {
                borders[0].alpha = 1
                borders[1].alpha = 0
            }
        }
        
    }
    
    func deactivate(cell: UITableViewCell, index: IndexPath) {
        durationPickers[index.row].removeFromSuperview()
    }
    
    @objc func durationDidChange(_ sender: UIDatePicker) {
        
        if sender.tag == 0 {
            self.roundDuration = sender.countDownDuration
            self.checkInDuration = min(self.checkInDuration, self.roundDuration)
            self.gpsActivation = min(self.gpsActivation, self.roundDuration)
            
            
            update(label: labels[0], withInterval: self.roundDuration)
            update(label: labels[1], withInterval: self.checkInDuration)
            update(label: labels[2], withInterval: self.gpsActivation)
            durationPickers[1].countDownDuration = self.checkInDuration
            durationPickers[2].countDownDuration = self.gpsActivation
        } else if sender.tag == 1{
            
            self.checkInDuration = min(sender.countDownDuration, self.roundDuration)
            update(label: labels[1], withInterval: self.checkInDuration)
            durationPickers[1].countDownDuration = self.checkInDuration
        } else {
            self.gpsActivation = min(sender.countDownDuration, self.roundDuration)
            update(label: labels[2], withInterval: self.gpsActivation)
            durationPickers[2].countDownDuration = self.gpsActivation
        }
        
        
    }

    
    @objc func createGame() {

        self.roundDuration = durationPickers[0].countDownDuration
        self.checkInDuration = durationPickers[1].countDownDuration
        self.gpsActivation = durationPickers[2].countDownDuration
        
        if editMode {
            updateGame()
            return
        }
        
        
        self.view.isUserInteractionEnabled = false
        alerts.startProgressHud(withMsg: "Creating Game", style: .dark)
        
        guard let gameTitle = eventNameField.text else {
            alerts.triggerCallback()
            return
        }
        guard gameTitle != "" else {
            alerts.triggerCallback()
            return
        }
        
        internalError = true
        
        let durations = [roundDuration, checkInDuration, gpsActivation]
        let decisions = [teamDecisionType, seekDecisionType]
        
        let game = Game(gameid: LogicSuite.uuid(), admin: self.admin, title: gameTitle, datetime: self.date, round_checkin_gps: durations, team_seek: decisions, img: eventImageHeader.image)

        self.admin.gameIDs[game.uid] = self.admin.username
        self.admin.games.append(game)
        
        FirebaseAPIClient.uploadGame(game: game, withPhoto: eventImageHeader.image != nil, success: {
            FirebaseAPIClient.updateRemoteUser(usr: self.admin, success: {
                self.successCreation = true
                self.alerts.triggerCallback()
            }, fail: {
                self.alerts.triggerCallback()
            })
        }) {
            self.alerts.triggerCallback()
        }
        
    }
    
    func updateGame() {
        self.view.isUserInteractionEnabled = false
        alerts.startProgressHud(withMsg: "Updating Game", style: .dark)
        
        guard let g = self.game else {
            alerts.triggerCallback()
            return
        }
        
        guard let gameTitle = eventNameField.text else {
            alerts.triggerCallback()
            return
        }
        guard gameTitle != "" else {
            alerts.triggerCallback()
            return
        }
        
        
        internalError = true
        
        g.title = gameTitle
        g.datetime = self.date
        
        g.roundDuration = self.roundDuration
        g.checkInDuration = self.checkInDuration
        g.gpsActivation = self.gpsActivation
        
        g.teamSelection = self.teamDecisionType
        g.seekSelection = self.seekDecisionType
        
        
        FirebaseAPIClient.updateRemoteGame(game: g, success: {
            if self.photoChanged {
                FirebaseAPIClient.uploadGamePhoto(forGame: g, withImage: self.eventImageHeader.image!, success: {
                    self.successCreation = true
                    self.alerts.triggerCallback()
                }, fail: {
                    self.alerts.triggerCallback()
                })
            } else {
                self.successCreation = true
                self.alerts.triggerCallback()
            }
        }) {
            self.alerts.triggerCallback()
        }
        
    }
    
    

}
