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
        intervalPicker.minuteInterval = 5
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
        
    }
    
    @objc func checkin(_ sender: UIButton) {
        
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

    
}
