//
//  ActiveGameVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/9/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import ARMDevSuite
import FirebaseDatabase
import CoreLocation
import MapKit

extension ActiveGameVC {
	func setUpChangeListener() {
		var lastChanged = Date()
		
		var isScheduled = false
		
		func executeUpdate() {
			FirebaseAPIClient.updateGame(self.game, completion: {
				self.updateLocalNotification(status: self.game.currentRound.roundStatus)
				if !self.game.active && !self.game.finished { // If it's no longer active dismiss, unless it's also finished
					self.navigationController?.popViewController(animated: true)
				}
				
				self.updateUIComponents()
				isScheduled = false
			})
		}
		
		func scheduleUpdate() {
			guard !isScheduled else { return }
			isScheduled = true
			Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { (_) in
				executeUpdate()
			}
		}
		
		Database.database().reference().child("games").child(self.game.uid).observe(.childChanged) { (_) in
			scheduleUpdate()
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
		self.game.currRoundNumber += 1
		FirebaseAPIClient.updateRemoteGame(game: self.game, success: {
			self.updateUIComponents()
		}) {
			self.game.currRoundNumber-=1
			self.updateUIComponents()
		}
	}
	
	@objc func setHidingTime(_ sender: UIButton) {
		let pop = InfoController()
		pop.titleText = "Set Hiding Time"
		
		
		
		let intervalPicker = UIDatePicker(frame: CGRect(x: .PADDING, y: 120, width: min(view.frame.width - 4 * .PADDING, 400), height: 125))
		intervalPicker.setValue(UIColor.white, forKey: "textColor")
		intervalPicker.datePickerMode = .countDownTimer
		intervalPicker.minuteInterval = 1
		//        intervalPicker.countDownDuration = TimeInterval(exactly: 1 * 60)!
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
			
			if self.game.finished {
				self.game.active = false
			}
			
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
	
	func updateLocalData() {
		LocalData.putLocalData(forKey: .activeGameID, data: self.game.uid)
		if let teamID = self.game.getTeamFor(player: self.user)?.uid {
			LocalData.putLocalData(forKey: .activeTeamID, data: teamID)
			
		}
		LocalData.putLocalData(forKey: .activeRoundID, data: self.game.currentRound.uid)
	}
	
	
	
	func updateLocalNotification(status: RoundStatus) {
		if status == RoundStatus.notStarted {
			NotificationsHelper.clearLocalNotifications()
		} else if status == RoundStatus.seekerHidingDuration {
			NotificationsHelper.clearLocalNotifications()
		} else if status == RoundStatus.hiding {
			NotificationsHelper.setCheckInTimer(everySeconds: self.game.checkInDuration, gameID: self.game.uid)
			NotificationsHelper.setEndHideTimer(game: self.game)
			NotificationsHelper.setEndOfGameTimer(game: self.game)
			NotificationsHelper.setGPSActivationTimer(game: self.game)
		} else if status == RoundStatus.seek {
			
		} else if status == RoundStatus.seekWithGPS {
			
		} else if status == RoundStatus.gameOver {
			NotificationsHelper.clearLocalNotifications()
		}
	}
	
	@objc func updateCurrentLocation() {
		guard let teamID = self.game.getTeamFor(player: self.user)?.uid else { return }
		
		if roundMap.userLocation.coordinate.latitude == 0 && roundMap.userLocation.coordinate.longitude == 0 {
			return
		}
		
		self.round.teamLocations[teamID] = roundMap.userLocation.location
		FirebaseAPIClient.updateRemoteGame(game: self.game, success: {}, fail: {})
	}
	
	
	
	func showOtherPlayers() {
		roundMap.removeAnnotations(teamLocationAnnotations)
		teamLocationAnnotations = []
		
		for (teamID, location) in self.round.teamLocations {
			if self.game.getTeamFor(player: self.user)?.uid == teamID {
				continue
			}
			
			let annotation = MKPointAnnotation()
			annotation.coordinate = location.coordinate
			annotation.title = self.game.teams[teamID]?.name
			
			let oldNess = Date().timeIntervalSince(location.timestamp)
			
			if oldNess < 60 {
				annotation.subtitle = "updated \(Int(oldNess)) seconds ago"
			} else if oldNess < 60 * 60 {
				annotation.subtitle = "updated \(Int(oldNess/60)) minutes ago"
			} else {
				annotation.subtitle = "updated \(Int(oldNess/60 / 60)) hours ago"
			}
			
			
			teamLocationAnnotations.append(annotation)
			roundMap.addAnnotation(annotation)
		}
		
	}
	
	@objc func updateUIComponents() {
		// Instruction
		if getIntervals()[0] < 0 && round.roundStatus == .hiding {
			round.roundStatus = .seek
			FirebaseAPIClient.updateRemoteGame(game: self.game, success: {}, fail: {})
		}
		
		if round.roundStatus != RoundStatus.gameOver && self.round.teamsCaught.count == (self.game.teams.count - 1) {
			// Game status is not over, but we captured everyone
			self.round.roundStatus = RoundStatus.gameOver
			FirebaseAPIClient.updateRemoteGame(game: self.game, success: {}, fail: {})
			return
		}
		
		
		gameStatusSwitcher?.invalidate()
		
		if round.roundStatus == RoundStatus.notStarted && self.userIsAdmin {
			gameStatus.text = "Start \(self.round.name!)"
		} else if round.roundStatus == RoundStatus.gameOver {
			
			let initialText = "Game Over: " + (self.round.winners.contains(self.round.seeker!) ? "Seekers win!" : "Hiders win!")
			gameStatus.text = initialText
			
			gameStatusSwitcher = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (t) in
				var statusBarOptions = [initialText]
				statusBarOptions.append(contentsOf: self.round.winners.map({ (t) -> String in
					
					let fullNames = Array(t.memberIDs.values)
					var names = [String]()
					
					for name in fullNames {
						let firstName = String(name.prefix(while: { (character) -> Bool in
							return character != " "
						}))
						names.append(firstName)
					}
					
					return "\(t.name!): " + names.joined(separator: ", ")
				}))
				
				
				self.gameStatus.text = statusBarOptions[self.gameStatusIndex]
				self.gameStatusIndex = (self.gameStatusIndex + 1) % statusBarOptions.count
			})
			
		} else {
			if self.userIsSeeker {
				gameStatus.text = round.roundStatus.seekDescription
			} else {
				gameStatus.text = round.roundStatus.description
			}
		}
		
		// Map Bounds
		addToMap(pins: round.boundaryPoints)
		
		createCountDownCells()
		tableView.reloadData()
		
		refreshSideControls()
		
		if self.showLocation {
			self.showOtherPlayers()
		}
		
		// Ensure Local Data's got it down
		updateLocalData()
		
		
	}
	
	
	
	
}
