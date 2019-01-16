//
//  RoundDetailVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/29/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import MapKit
import CoreLocation
import iosManagers

extension RoundDetailVC {
    func initUI() {
        self.view.backgroundColor = .black
        
        seekerHeight = view.frame.height/8
        seekerFrame = CGRect(x: .PADDING, y: view.frame.height - (seekerHeight + 2 * .PADDING + 2 * getTabBarProxy().frame.height), width: view.frame.width - 2 * .PADDING, height: seekerHeight)
        
        initNav()
        initTextfield()
        
        if round.seeker == nil {
            if self.game.seekSelection == .Randomized {
                

                self.round.seeker = Array(self.game.teams.values)[myUtils.randomNum(upTo: self.game.teams.count)]
                initTeamView()
            } else {
                initTeamSelected()
            }
        } else {
            initTeamView()
        }
        
        
        initMap()
        
        if hasPermissions {
            addTapTracker()
        }
        
        
        for spot in self.round.boundaryPoints {
            addToMap(pinAt: spot)
        }
        
    }

    // UI Initialization Helpers
    func initNav() {
        self.title = round.name
        
        
        if hasPermissions {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishEditingRound))
            
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor : rgb(162,162,162)], for: .disabled)
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor : UIColor.ACCENT_BLUE], for: .normal)
            setBarButton(valid: true)
        }
        
        
        
    }
    
    func initTextfield() {
        roundName = LabeledTextField(frame: CGRect(x: .PADDING, y: .PADDING, width: view.frame.width - (2 * .PADDING), height: view.frame.width/6))
        view.addSubview(roundName)
        
        roundName.placeholder = "Round Name"
        roundName.placeholderColor = rgba(162,162,162,1)
        roundName.placeholderFont = UIFont.SUBTITLE_FONT
        
        roundName.text = round.name
        roundName.textColor = .white
        roundName.font = UIFont.SUBTITLE_FONT
        
        roundName.selectedLineColor = .ACCENT_BLUE
        roundName.selectedTitleColor = .ACCENT_BLUE
        
        roundName.titleFont = UIFont.TEXT_FONT!.bold
        roundName.titleColor = rgba(162,162,162,1)
        roundName.returnKeyType = .continue
        
        roundName.errorColor = .ACCENT_RED
        
        roundName.addTarget(self, action: #selector(changeTitle), for: .editingChanged)
        roundName.addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
        roundName.additionalDistance = 0
        roundName.autocorrectionType = .yes
        
        roundName.isUserInteractionEnabled = hasPermissions
        
    }
    
    func initTeamSelected() {
        selectTeamButton = UIButton(frame: seekerFrame)
        selectTeamButton.setBackgroundColor(color: .black, forState: .normal)
        selectTeamButton.setBackgroundColor(color: .flatBlackDark, forState: .highlighted)
        
        selectTeamButton.titleLabel?.font = .HEADER_FONT
        selectTeamButton.layer.cornerRadius = 5
        selectTeamButton.layer.borderColor = UIColor.white.cgColor
        selectTeamButton.layer.borderWidth = 0.75
        selectTeamButton.clipsToBounds = true
        
        if hasPermissions {
            selectTeamButton.setTitle("Pick Seekers", for: .normal)
            selectTeamButton.addTarget(self, action: #selector(toTeamSelect), for: .touchUpInside)
        } else {
            selectTeamButton.setTitle("No Seekers Selected", for: .normal)
        }
        view.addSubview(selectTeamButton)
    }
    
    func initTeamView() {
        selectedTeam = UIView(frame: seekerFrame)
        view.addSubview(selectedTeam)
        
        let border = UIView(frame: CGRect(x: 0, y: 0, width: seekerFrame.width, height: seekerFrame.height))
        
        border.layer.cornerRadius = 5
        border.layer.borderColor = UIColor.white.cgColor
        border.layer.borderWidth = 0.75
        selectedTeam.addSubview(border)
        
        guard let team = self.round.seeker else { return }
        
        let number = ((abs(CGFloat(team.uid.hashValue))/pow(2,63)) * 180 * 10).truncatingRemainder(dividingBy: 180)
        let initials: String = String(team.name.split(separator: " ").map { (sub) -> Substring in return sub.prefix(1)}.reduce("", +).prefix(2))
        
        let pseudoimgview = UIButton(frame: CGRect(x: .PADDING, y: 0, width: selectedTeam.frame.height - .PADDING, height: selectedTeam.frame.height - .PADDING))
        pseudoimgview.center = CGPoint(x: pseudoimgview.frame.midX, y: selectedTeam.frame.height/2)
        
        pseudoimgview.setTitle(initials, for: .normal)
        pseudoimgview.setTitleColor(.white, for: .normal)
        pseudoimgview.titleLabel?.font = UIFont.TEXT_FONT?.bold
        
        pseudoimgview.layer.cornerRadius = pseudoimgview.frame.width/2
        pseudoimgview.clipsToBounds = true
        pseudoimgview.imageView?.contentMode = .scaleAspectFill
        
        if let img = team.img {
            pseudoimgview.setImage(img, for: .normal)
        }
        
        pseudoimgview.setBackgroundColor(color: UIColor.ACCENT_RED.modified(withAdditionalHue: number, additionalSaturation: 0, additionalBrightness: 0), forState: .normal)
        selectedTeam.addSubview(pseudoimgview)
        
        let teamName = UILabel(frame: CGRect(x: pseudoimgview.frame.maxX + .PADDING, y: 0, width: selectedTeam.frame.width - (pseudoimgview.frame.maxX + 2 * .PADDING), height: 30))
        teamName.center = CGPoint(x: teamName.frame.midX, y: selectedTeam.frame.height/2 + 5)
        teamName.adjustsFontSizeToFitWidth = true
        teamName.font = .SUBTITLE_FONT
        teamName.textColor = .white
        teamName.text = self.round.seeker?.name
        selectedTeam.addSubview(teamName)
        
        let buttonDiameter: CGFloat = 40
        let removeTeam = UIButton(frame: CGRect(x: selectedTeam.frame.width - buttonDiameter/2, y: 10-buttonDiameter/2, width: buttonDiameter, height: buttonDiameter))
        removeTeam.setBackgroundColor(color: .ACCENT_RED, forState: .normal)
        removeTeam.setTitle("X", for: .normal)
        removeTeam.setTitleColor(.white, for: .normal)
        removeTeam.titleLabel?.font = .HEADER_FONT
        removeTeam.layer.cornerRadius = removeTeam.frame.width/2
        removeTeam.clipsToBounds = true
        
        if hasPermissions {
            selectedTeam.addSubview(removeTeam)
            removeTeam.addTarget(self, action: #selector(removeSeekers), for: .touchUpInside)
        }
        
        
    }
    
    func setTeamVisible(_ bool: Bool) {
        if bool {
            selectTeamButton.removeFromSuperview()
            initTeamView()
            if selectedTeam != nil {
                view.addSubview(selectedTeam)
            }
        } else {
            selectedTeam.removeFromSuperview()
            initTeamSelected()
            if selectTeamButton != nil {
                view.addSubview(selectTeamButton)
            }
        }
    }
    
    
    func getTabBarProxy() -> UIView {
        let tabFrame = (tabBarController?.tabBar.frame)!
        let actualTabFrame = CGRect(origin: CGPoint(x: tabFrame.minX, y: tabFrame.minY-tabFrame.height), size: CGSize(width: tabFrame.width, height: tabFrame.height))
        return UIView(frame: actualTabFrame)
    }
    
    func addTapTracker() {
        tapTracker = UITapGestureRecognizer(target: self, action: #selector(tapReceived))
        tapTracker.delegate = self
        view.addGestureRecognizer(tapTracker)
    }
    
    
    

}
