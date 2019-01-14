//
//  ActiveGameVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/9/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers
import FirebaseDatabase

extension ActiveGameVC {
    func setUpChangeListener() {
        Database.database().reference().child("games").child(self.game.uid).observe(.childChanged) { (_) in
            FirebaseAPIClient.updateGame(self.game, completion: {
                debugPrint(self.game.checkInDuration)
                self.updateLocalNotification(status: self.game.currentRound.roundStatus)
                if self.game.active == false {
                    self.navigationController?.popViewController(animated: true)
                }
                
                
                self.updateUIComponents()
            })
        }
    }
    
    @objc func startRound(_ sender: UIButton) {
        pauseScreen(withSender: sender)
        
        self.round.roundStatus = RoundStatus.seekerHidingDuration
        FirebaseAPIClient.updateRemoteGame(game: self.game, success: {
            self.updateUIComponents()
            self.resumeScreen(withSender: sender)
        }) {
            self.resumeScreen(withSender: sender)
        }
    }
    
    @objc func nextRound(_ sender: UIButton) {
        
    }
    
    @objc func setHidingTime(_ sender: UIButton) {
        let pop = InfoController()
        pop.titleText = "Set Hiding Time"
        
        
        
        let intervalPicker = UIDatePicker(frame: CGRect(x: .PADDING, y: 120, width: min(view.frame.width - 4 * .PADDING, 400), height: 125))
        intervalPicker.setValue(UIColor.white, forKey: "textColor")
        intervalPicker.datePickerMode = .countDownTimer
        intervalPicker.minuteInterval = 1
        intervalPicker.countDownDuration = TimeInterval(exactly: 15 * 60)!
        
        pop.addSubview(intervalPicker)
        
        
        pop.actionText = "Set Time"
        pop.actionCallback = {
            self.round.hidingTime = intervalPicker.countDownDuration
            self.round.startHide = Date()
            self.round.roundStatus = RoundStatus.hiding
            self.round.startTime = Date().addingTimeInterval(self.round.hidingTime)
            
            FirebaseAPIClient.updateRemoteGame(game: self.game, success: {
                self.updateUIComponents()
            }, fail: {})
            
        }
        
        
        pop.finalCallback = {
            
        }
        
        pop.presentIn(view: self.view)
    }
    
    @objc func openChat(_ sender: UIButton) {
        myUtils.showChatVCFor(game: self.game, perspectiveOf: self.user, fromVC: self.navigationController!)
    }
    
    @objc func caughtPerson(_ sender: UIButton) {

        let caughtTeamPicker = TeamSelectorVC()
        caughtTeamPicker.game = self.game
        caughtTeamPicker.explictTeamList = (Array(self.game.teams.values) as! [Team]).filter({ (team) -> Bool in return !isSeeker(team)})
        
        caughtTeamPicker.callback = { (team) in
            self.round.teamsCaught[team.uid] = team.name
            FirebaseAPIClient.updateRemoteGame(game: self.game, success: {
                
                let txt = "\(self.game.getTeamFor(player: self.user)!.name!) caught \(team.name!)"
                
                let msg = Message(msg: txt, sender: self.user)
                
                let chats = myUtils.showChatVCFor(game: self.game, perspectiveOf: self.user, fromVC: self.navigationController!)
                chats.preloadedText = txt
                
            }, fail: {
                return
            })
            
        }

        self.navigationController?.pushViewController(caughtTeamPicker, animated: true)
        
        
        
    }
    
    @objc func checkin(_ sender: UIButton) {
        FirebaseAPIClient.checkIn(by: self.user, forGame: self.game) {
            self.updateUIComponents()
        }
    }
    
    
    func pauseScreen(withSender: UIButton) {
        withSender.isHighlighted = true
        self.view.isUserInteractionEnabled = false
    }
    
    func resumeScreen(withSender: UIButton) {
        withSender.isHighlighted = false
        self.view.isUserInteractionEnabled = true
    }
    
    func tabChanged(index: Int) {
        tableView.reloadData()
    }
    
    
    
    
    
    func updateLocalNotification(status: RoundStatus) {
        if status == RoundStatus.notStarted {
            NotificationsHelper.clearLocalNotifications()
        } else if status == RoundStatus.seekerHidingDuration {
            NotificationsHelper.clearLocalNotifications()
        } else if status == RoundStatus.hiding {
            NotificationsHelper.setCheckInTimer(everySeconds: self.game.checkInDuration, gameID: self.game.uid)
            NotificationsHelper.setGameEndTimer(game: self.game)
        } else if status == RoundStatus.seek {
            
        } else if status == RoundStatus.seekWithGPS {
            
        } else if status == RoundStatus.gameOver {
            NotificationsHelper.clearLocalNotifications()
        }
    }

    
}
