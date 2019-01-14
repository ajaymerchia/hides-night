//
//  ActiveGameVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/7/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers
import MapKit

extension ActiveGameVC {
    func initUI() {
        self.view.backgroundColor = .black
        initNav()
        initLabels()
        initMap()
        initSideControls()
        initSegControl()
        createCountDownCells()
        initTableview()
        
    }

    // UI Initialization Helpers
    func initNav() {
        self.title = "Game"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.nav_info_small.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(goToDetails))
    }
    
    func initLabels() {
        gameTitle = UILabel(frame: LayoutManager.belowCentered(elementAbove: UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0)), padding: .PADDING, width: view.frame.width, height: 40))
        gameTitle.text = game.title
        gameTitle.textColor = .white
        gameTitle.font = .SUBTITLE_FONT
        gameTitle.textAlignment = .center
        gameTitle.adjustsFontSizeToFitWidth = true
        view.addSubview(gameTitle)
        
        gameStatus = UILabel(frame: LayoutManager.belowCentered(elementAbove: gameTitle, padding: -.MARGINAL_PADDING, width: view.frame.width, height: 30))
        gameStatus.textAlignment = .center
        
        gameStatus.textColor = .white
        gameStatus.font = UIFont.BIG_TEXT_FONT?.italic
        gameStatus.adjustsFontSizeToFitWidth = true
        view.addSubview(gameStatus)
    }

    func initMap() {
        roundMap = MKMapView(frame: LayoutManager.belowLeft(elementAbove: gameStatus, padding: .PADDING, width: view.frame.width - self.sideControlWidth, height: view.frame.height/2.5))
        roundMap.delegate = self
        roundMap.showsUserLocation = true
        
        roundMap.layer.cornerRadius = 15
        
        view.addSubview(roundMap)
        initRecenter()
        
    }
    
    func initRecenter() {
        let size: CGFloat = 1.4
        let recenterButton = UIButton(frame: CGRect(x: roundMap.frame.maxX - size * 1.2 * .PADDING, y: roundMap.frame.maxY - size * 1.2 * .PADDING, width: size * .PADDING, height: size * .PADDING))
        recenterButton.setImage(UIImage(named: "recenter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        recenterButton.tintColor = borderColor
        recenterButton.layer.backgroundColor = UIColor.white.cgColor
        recenterButton.layer.cornerRadius = recenterButton.frame.width/2
        let insetamt:CGFloat = 3
        recenterButton.imageEdgeInsets = UIEdgeInsets(top: insetamt, left: insetamt, bottom: insetamt, right: insetamt)
        
        recenterButton.imageView?.layer.cornerRadius = .PADDING/2
        recenterButton.imageView?.contentMode = .scaleAspectFit
        recenterButton.addTarget(self, action: #selector(recenter), for: .touchUpInside)
        view.addSubview(recenterButton)
    }
    
    func initSideControls() {
        sideControls = UIView(frame: CGRect(x: roundMap.frame.maxX, y: roundMap.frame.minY, width: sideControlWidth, height: roundMap.frame.height))
        
        
        var controlViews = [UIView]()
        
        // definitely add chat
        let chatControls = prepareControlsWith(text: "Chat", image: .mark_chat, tint: .ACCENT_BLUE, action: #selector(openChat))
        openChatButton = chatControls.0
        controlViews.append(chatControls.1)
        
        
        
        
        if round.roundStatus == .notStarted && userIsAdmin {
            // if game not started and this is an admin, add the "start game" button
            let startControls = prepareControlsWith(text: "Start Round", image: .mark_play, tint: .ACCENT_GREEN, action: #selector(startRound))
            startGameButton = startControls.0
            controlViews.append(startControls.1)
        } else if round.roundStatus == RoundStatus.gameOver && userIsAdmin {
            // else if gameover and this is an admin, add the "next round" button
            let nextControls = prepareControlsWith(text: "Next Round", image: .mark_next, tint: .ACCENT_GREEN, action: #selector(nextRound))
            nextGameButton = nextControls.0
            controlViews.append(nextControls.1)
        } else if round.roundIsActive {
            // else if game in session, enable checkins
            let checkinControls = prepareControlsWith(text: "Check In", image: .mark_check, tint: .ACCENT_GREEN, action: #selector(checkin))
            checkInButton = checkinControls.0
            controlViews.append(checkinControls.1)
        }
        
        // if seeker and game in session, enable "caught someone"
        if round.roundIsActive && round.roundStatus != .hiding && self.userIsSeeker {
            let caughtControls = prepareControlsWith(text: "Caught One", image: .mark_catch, tint: .ACCENT_RED, action: #selector(caughtPerson))
            caughtButton = caughtControls.0
            controlViews.append(caughtControls.1)
        }
        
        if round.roundStatus == .seekerHidingDuration && self.userIsSeeker {
            let timerControls = prepareControlsWith(text: "Hiding Time", image: .mark_timer, tint: .ACCENT_RED, action: #selector(setHidingTime))
            timerButton = timerControls.0
            controlViews.append(timerControls.1)
        }
        
        
        let spaceHeight: CGFloat = sideControls.frame.height/CGFloat(controlViews.count)
        
        for i in 0..<controlViews.count {
            let reservedSpace = CGRect(x: 0, y: spaceHeight * CGFloat(i), width: sideControlWidth, height: spaceHeight)
            controlViews[i].center = CGPoint(x: reservedSpace.midX, y: reservedSpace.midY)
            sideControls.addSubview(controlViews[i])
            
        }
        
        view.addSubview(sideControls)
    }
    
    func prepareControlsWith(text: String, image: UIImage, tint: UIColor, action: Selector) -> (UIButton, UIView) {
        
        let buttonSize: CGFloat = sideControlWidth * 0.65
        let inset: CGFloat = 9

        let newButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        newButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        newButton.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        newButton.setBackgroundColor(color: .clear, forState: .normal)
        newButton.setBackgroundColor(color: tint, forState: .highlighted)
        
        newButton.tintColor = tint
        newButton.clipsToBounds = true
        
        newButton.layer.cornerRadius = newButton.frame.width/2
        newButton.layer.borderColor = tint.cgColor
        newButton.layer.borderWidth = 0.75
        newButton.addTarget(self, action: action, for: .touchUpInside)
        
        let newLabel = UILabel(frame: CGRect(x: 0, y: buttonSize + .MARGINAL_PADDING, width: buttonSize, height: 30))
        newLabel.text = text
        newLabel.textAlignment = .center
        newLabel.font = UIFont.LIGHT_TEXT_FONT
        newLabel.textColor = tint
        newLabel.adjustsFontSizeToFitWidth = true
        
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: buttonSize, height: newLabel.frame.maxY))
        newView.addSubview(newButton)
        newView.addSubview(newLabel)
        
        return (newButton, newView)
        
    }
    
    @objc func updateUIComponents() {
        // Instruction
        if getIntervals()[0] < 0 && round.roundStatus == .hiding {
            round.roundStatus = .seek
            FirebaseAPIClient.updateRemoteGame(game: self.game, success: {}, fail: {})
        }
        
        if round.roundStatus == RoundStatus.notStarted && self.userIsAdmin {
            gameStatus.text = "Start \(self.round.name!)"
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
        
    }
    func refreshSideControls() {
        for view in sideControls.subviews {
            view.removeFromSuperview()
        }
        initSideControls()
    }
    
    
    func initTableview() {
        tableView = UITableView(frame: LayoutManager.between(elementAbove: indicatorView, elementBelow: getTabBarProxy(), width: view.frame.width, topPadding: 0, bottomPadding: 0))
        tableView.center = CGPoint(x: view.frame.width/2, y: tableView.frame.midY)
        tableView.register(GameCell.self, forCellReuseIdentifier: "teamCell")
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)

    }
    
    func createCountDownCells() {
        self.countdownCells = []
        let titles = ["Time to Hide", "Time Left", "Time Until GPS Activation", "Time Until Next Check-In"]
        let intervals: [TimeInterval] = getIntervals()
        
        for i in 0..<titles.count {
            let cell = CountDownCell()
            debugPrint(intervals[i])
            if intervals[i] > 0 {
                cell.initializeCellFrom(time: intervals[i], title: titles[i], size: CGSize(width: view.frame.width, height: heightComputer()))
                cell.countdown.countdownDelegate = self
            }
            
            self.countdownCells.append(cell)
        }
        
    }
    
    func getIntervals() -> [TimeInterval] {
        var intervals = [TimeInterval]()
        
        // Get the hiding time leftover
        var hidingTime = round.hidingTime
        if let startHide = round.startHide {
            let timePass = Date().timeIntervalSince(startHide)
            hidingTime = round.hidingTime - timePass
        }
        intervals.append(hidingTime)
        
        let titles = ["Round Duration", "GPS Activation", "Check In Duration"]
        debugPrint(game.roundDuration, game.gpsActivation, game.checkInDuration)
        let otherTimes = [game.roundDuration, game.gpsActivation, game.checkInDuration]
        
        var i = 0
        debugPrint("----------------------------------------")
        debugPrint("----------------------------------------")
        
        for time in otherTimes {
            var fullInterval: TimeInterval = time!
            if let gameStart = round.startTime {
                
                var referenceTime = self.round.roundStatus == .hiding ? self.round.startHide : self.round.startTime
                
                let fullIntervalSeconds = Int(fullInterval)
                let timeDifferenceSeconds = Int(Date().timeIntervalSince(referenceTime!))
                let timePassModulated = timeDifferenceSeconds % fullIntervalSeconds
                
                
                debugPrint(titles[i])
                debugPrint("----------------------------------------")
                debugPrint("Full Interval was \(fullInterval/60) minutes")

                fullInterval = TimeInterval(exactly: (Int(fullInterval) - timePassModulated))!
                
                debugPrint("Time Differenc was \(timeDifferenceSeconds/60) minutes")
                debugPrint("Time Pass Modulated was \(timePassModulated/60) minutes")
                
                
                i+=1
                debugPrint("Reference Time was " + myUtils.getTimeWithAMPM(date: referenceTime!))
                debugPrint("Current Time was " + myUtils.getTimeWithAMPM(date: Date()))
                debugPrint("Time Difference was ")
                
                debugPrint("Full Interval become \(fullIntervalSeconds/60) minutes")
                
            }
            
            intervals.append(fullInterval)
        }
        debugPrint("----------------------------------------")
        debugPrint("----------------------------------------")
        
        return intervals
    }
    
}
