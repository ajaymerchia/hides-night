//
//  GameDetailVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/27/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension GameDetailVC: UIGestureRecognizerDelegate {
    func initUI() {
        self.view.backgroundColor = .black
        initNav()
        initGamePhoto()
        initLabels()
        
        initControlButtons()
        initSegControl()
        initCellCreator()
        initTableview()
        
        changeDimensionsIfNeeded()
        resetGameDetails()
        
        
    }

    // UI Initialization Helpers
    func initNav() {
        navbar = self.navigationController!.navigationBar
        self.title = "Game"
    }
    
    func initGamePhoto() {
        gamePhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/4))
        gamePhoto.backgroundColor = .flatBlack
        gamePhoto.image = game.img
        gamePhoto.contentMode = .scaleAspectFill
        gamePhoto.clipsToBounds = true
        view.addSubview(gamePhoto)
        
        gameParamToggler = UITapGestureRecognizer(target: self, action: #selector(toggleGameParams))
        gameParamToggler.delegate = self
        view.addGestureRecognizer(gameParamToggler)
    
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableView) == true {
            return false
        }
        return true
    }
    
    
    
    
    func animateParams(to: CGFloat) { UIView.animate(withDuration: 0.33, animations: {self.gameParams.alpha = to == 0 ? 0 : 1; self.gameParams.backgroundColor = rgba(0,0,0,to)})}
    @objc func toggleGameParams() {
        if gameParamToggler.location(in: self.view).y < gamePhoto.frame.maxY {
            animateParams(to: gameParamsHidden ? 0 : 0.75)
            gameParamsHidden = !gameParamsHidden
        }
    }
    
    func resetGameDetails() {
        if gameParams != nil {
            gameParams.removeFromSuperview()
        }
        gameParams = UIView(frame: gamePhoto.frame)
        gameParams.backgroundColor = .black
        gameParams.alpha = 0
        view.addSubview(gameParams)
        
        let intraHalfPadding = 3 * .MARGINAL_PADDING
        let middlePaddingWeight:CGFloat = 0.5
        
        let threeWidth = (view.frame.width - 2 * .PADDING)/3
        let threeTitles = ["Round Lasts", "Check-in Every", "GPS after"]
        let threeValues: [String] = [self.game.roundDuration, self.game.checkInDuration, self.game.gpsActivation].map { (interval) -> String in
            return myUtils.getFormattedCountdown(interval: interval)
        }
        for i in 0..<3 {
            let paramTitle = threeTitles[i]
            let label = UILabel(frame: CGRect(x: .PADDING + threeWidth * CGFloat(i), y: intraHalfPadding * (2-middlePaddingWeight), width: threeWidth, height: gameParams.frame.height/6))
            label.text = paramTitle
            formatLabel(label: label, light: true)
            gameParams.addSubview(label)
            
            let valueTitle = threeValues[i]
            let valueLabel = UILabel(frame: LayoutManager.belowCentered(elementAbove: label, padding: 0, width: threeWidth, height: (gameParams.frame.height/2 - 2 * intraHalfPadding) - label.frame.height))
            valueLabel.text = valueTitle
            formatLabel(label: valueLabel, light: false)
            gameParams.addSubview(valueLabel)
            
        }
        
        
        let twoWidth = (view.frame.width - 2 * .PADDING)/2
        let twoTitles = ["Team Selection", "Seeker Selection"]
        let twoValues: [String] = [self.game.teamSelection, self.game.seekSelection].map { (type) -> String in
            return (type?.description)!
        }
        for i in 0..<2 {
            let paramTitle = twoTitles[i]
            let label = UILabel(frame: CGRect(x: .PADDING + twoWidth * CGFloat(i), y: gameParams.frame.height/2 + intraHalfPadding * (middlePaddingWeight), width: twoWidth, height: gameParams.frame.height/6))
            label.text = paramTitle
            formatLabel(label: label, light: true)
            gameParams.addSubview(label)
            
            let valueTitle = twoValues[i]
            let valueLabel = UILabel(frame: LayoutManager.belowCentered(elementAbove: label, padding: 0, width: twoWidth, height: (gameParams.frame.height/2 - 2 * intraHalfPadding) - label.frame.height))
            valueLabel.text = valueTitle
            formatLabel(label: valueLabel, light: false)
            gameParams.addSubview(valueLabel)
            
        }
        
    }
    
    func formatLabel(label: UILabel, light: Bool) {
        label.textAlignment = .center
        label.textColor = .white
        label.font = light ? UIFont.LIGHT_TEXT_FONT : UIFont.BIG_TEXT_FONT?.bold
        label.adjustsFontSizeToFitWidth = true
        
//        if light {
//            gameParams.addSubview(Utils.getBorder(forView: label, thickness: 0.5, color: .white, side: .Bottom))
//        }
        
    }
    
    func initLabels() {
        gameTitle = UILabel(frame: LayoutManager.belowCentered(elementAbove: gamePhoto, padding: .PADDING, width: view.frame.width, height: 40))
        gameTitle.text = game.title
        gameTitle.textColor = .white
        gameTitle.font = .SUBTITLE_FONT
        gameTitle.textAlignment = .center
        gameTitle.adjustsFontSizeToFitWidth = true
        view.addSubview(gameTitle)
        
        gameTime = UILabel(frame: LayoutManager.belowCentered(elementAbove: gameTitle, padding: -.MARGINAL_PADDING, width: view.frame.width, height: 30))
        gameTime.textAlignment = .center
        gameTime.text = myUtils.getFormattedDateAndTime(date: game.datetime)
        gameTime.textColor = .white
        gameTime.font = UIFont.BIG_TEXT_FONT?.italic.bold
        view.addSubview(gameTime)
    }
    
    func initControlButtons() {
        overallButtonHolder = UIView(frame: LayoutManager.belowCentered(elementAbove: gameTime, padding: .PADDING, width: view.frame.width, height: 30))
        view.addSubview(overallButtonHolder)
        
        let buttonFont = UIFont.TEXT_FONT
        let fontInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let distanceFromCenter: CGFloat = overallButtonHolder.frame.width/6
        let buttonWidth: CGFloat = overallButtonHolder.frame.width/4
        
        leftActionButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: overallButtonHolder.frame.height))
        leftActionButton.center = CGPoint(x: overallButtonHolder.frame.midX - distanceFromCenter, y: leftActionButton.frame.midY)
        
        leftActionButton.titleLabel?.font = buttonFont
        leftActionButton.titleEdgeInsets = fontInset
        leftActionButton.setBackgroundColor(color: .black, forState: .normal)
        leftActionButton.setTitleColor(.black, for: .highlighted)
        leftActionButton.setTitleColor(.black, for: .selected)

        leftActionButton.layer.cornerRadius = 5
        
        leftActionButton.layer.borderWidth = 0.75
        leftActionButton.clipsToBounds = true
        overallButtonHolder.addSubview(leftActionButton)
        
        
        let colorToUse: UIColor = self.userIsAdmin ? .ACCENT_GREEN : .ACCENT_RED
        let textToUse: String = self.userIsAdmin ? "Start" : "Leave"
        rightActionButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: overallButtonHolder.frame.height))
        rightActionButton.center = CGPoint(x: overallButtonHolder.frame.midX + distanceFromCenter, y: rightActionButton.frame.midY)
        
        rightActionButton.titleLabel?.font = buttonFont?.bold
        rightActionButton.titleEdgeInsets = fontInset
        rightActionButton.setBackgroundColor(color: .black, forState: .normal)
        rightActionButton.setTitleColor(.black, for: .highlighted)
        rightActionButton.setTitleColor(.black, for: .selected)
        
        rightActionButton.setBackgroundColor(color: colorToUse, forState: .highlighted)
        rightActionButton.setBackgroundColor(color: colorToUse, forState: .selected)
        rightActionButton.setTitle(textToUse, for: .normal)
        rightActionButton.setTitleColor(colorToUse, for: .normal)
        
        rightActionButton.layer.cornerRadius = 5
        rightActionButton.layer.borderColor = colorToUse.cgColor
        rightActionButton.layer.borderWidth = 0.75
        
        rightActionButton.clipsToBounds = true
        overallButtonHolder.addSubview(rightActionButton)
        
        
        // Model based button behavior
        configureButtonsForUser()
        
        
        
        
        
    }
    
    func configureButtonsForUser() {
        let textToUse: String = self.userIsAdmin ? "Start" : "Leave"
        
        
        if !isGameInvite {
            leftActionButton.setBackgroundColor(color: .ACCENT_BLUE, forState: .highlighted)
            leftActionButton.setBackgroundColor(color: .ACCENT_BLUE, forState: .selected)
            leftActionButton.setTitle("Chat", for: .normal)
            leftActionButton.setTitleColor(.ACCENT_BLUE, for: .normal)
            leftActionButton.layer.borderColor = UIColor.ACCENT_BLUE.cgColor
            
            leftActionButton.removeTarget(self, action: #selector(acceptInvite), for: .touchUpInside)
            leftActionButton.addTarget(self, action: #selector(openChat), for: .touchUpInside)

            
            rightActionButton.setTitle(textToUse, for: .normal)
            rightActionButton.removeTarget(self, action: #selector(declineInvite), for: .touchUpInside)
            
            if userIsAdmin {
                rightActionButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
            } else {
                rightActionButton.addTarget(self, action: #selector(leaveGame), for: .touchUpInside)
            }
            
            
        } else {
            leftActionButton.setBackgroundColor(color: .ACCENT_GREEN, forState: .highlighted)
            leftActionButton.setBackgroundColor(color: .ACCENT_GREEN, forState: .selected)
            leftActionButton.setTitle("Join", for: .normal)
            leftActionButton.setTitleColor(.ACCENT_GREEN, for: .normal)
            leftActionButton.layer.borderColor = UIColor.ACCENT_GREEN.cgColor
            
            
            leftActionButton.removeTarget(self, action: #selector(openChat), for: .touchUpInside)
            leftActionButton.addTarget(self, action: #selector(acceptInvite), for: .touchUpInside)
            
            rightActionButton.setTitle("Decline", for: .normal)

            rightActionButton.removeTarget(self, action: #selector(leaveGame), for: .touchUpInside)
            rightActionButton.addTarget(self, action: #selector(declineInvite), for: .touchUpInside)
            
            
        }
    }
    
    func initCellCreator() {
        
        
        
        createCellButton = UIButton(frame: LayoutManager.aboveCentered(elementBelow: getTabBarProxy(), padding: .PADDING, width: view.frame.width, height: 40))
        
        createCellButton.setTitle(createTitles[currentSegSelected], for: .normal)
        createCellButton.titleLabel?.font = .HEADER_FONT
        createCellButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        createCellButton.setTitleColor(.black, for: .normal)
        createCellButton.setBackgroundColor(color: .ACCENT_GREEN, forState: .normal)
        createCellButton.addTarget(self, action: #selector(openCreate), for: .touchUpInside)
        view.addSubview(createCellButton)
    }
    
    func getTabBarProxy() -> UIView {
        let tabFrame = (tabBarController?.tabBar.frame)!
        let actualTabFrame = CGRect(origin: CGPoint(x: tabFrame.minX, y: tabFrame.minY-tabFrame.height), size: CGSize(width: tabFrame.width, height: tabFrame.height))
        return UIView(frame: actualTabFrame)
    }

    func initTableview() {
        tableView = UITableView(frame: LayoutManager.between(elementAbove: indicatorView, elementBelow: createCellButton, width: view.frame.width, topPadding: 2 * .MARGINAL_PADDING, bottomPadding: 0))
        tableView.center = CGPoint(x: view.frame.width/2, y: tableView.frame.midY)
        tableView.register(PersonCell.self, forCellReuseIdentifier: "personCell")
        tableView.register(GameCell.self, forCellReuseIdentifier: "teamCell")
        tableView.register(RoundCell.self, forCellReuseIdentifier: "roundCell")
        // Register RoundCell & TeamCell
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
    }

}
