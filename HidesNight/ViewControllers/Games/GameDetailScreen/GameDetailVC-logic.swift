//
//  GameDetailVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/27/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension GameDetailVC {
    func tabChanged(index: Int) {
        changeDimensionsIfNeeded()
        createCellButton.setTitle(createTitles[index], for: .normal)
        tableView.reloadData()
        
        
    }
    
    func changeDimensionsIfNeeded() {
        if keepingCreateButton() {
            view.addSubview(createCellButton)
            tableView.frame = LayoutManager.between(elementAbove: indicatorView, elementBelow: createCellButton, width: view.frame.width, topPadding: 2 * .MARGINAL_PADDING, bottomPadding: 0)
            tableView.center = CGPoint(x: view.frame.width/2, y: tableView.frame.midY)

        } else {
            createCellButton.removeFromSuperview()
            tableView.frame = LayoutManager.between(elementAbove: indicatorView, elementBelow: getTabBarProxy(), width: view.frame.width, topPadding: 2 * .MARGINAL_PADDING, bottomPadding: 0)
            tableView.center = CGPoint(x: view.frame.width/2, y: tableView.frame.midY)

        }
    }
    
    func keepingCreateButton() -> Bool {
        switch currentSegSelected {
        case 0:
            return self.game.playerStatus[self.user.uid] != .invited
        case 1:
            return (self.user == game.admin && game.teamSelection != GameSelectionType.Randomized) || game.teamSelection == .Chosen
        default:
            return (self.user == game.admin)
        }
    }
    
    @objc func acceptInvite(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        sender.isSelected = true
        debugPrint("accpeting invite")
        
        FirebaseAPIClient.gameInvitationAccepted(by: self.user, forGame: self.game, success: {
            sender.isSelected = false
            self.view.isUserInteractionEnabled = true
            self.configureButtonsForUser()
            self.tableView.reloadData()
        }, fail: {})
        
    }
    
    @objc func declineInvite(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        sender.isSelected = true
        debugPrint("declining invite")
        
        FirebaseAPIClient.gameInvitationRejected(by: self.user, forGame: self.game, success: {
            sender.isSelected = false
            self.view.isUserInteractionEnabled = true
            self.navigationController?.popViewController(animated: true)
        }, fail: {})
    }
    
    @objc func openChat(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        sender.isSelected = true
        debugPrint("opening chat")
        sender.isSelected = false
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func leaveGame(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        sender.isSelected = true
        
        let actionSheet = UIAlertController(title: "Are you sure you want to leave the game?", message: "You won't be able to rejoin unless you are invited.", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            sender.isSelected = false
            self.view.isUserInteractionEnabled = true
        }))
        actionSheet.addAction(UIAlertAction(title: "Leave Game", style: .destructive, handler: { (action) -> Void in
            FirebaseAPIClient.gameLeft(by: self.user, fromGame: self.game, success: {
                sender.isSelected = false
                self.view.isUserInteractionEnabled = true
                self.navigationController?.popViewController(animated: true)
            }, fail: {})
        }))
        
        actionSheet.popoverPresentationController?.sourceView = rightActionButton
        
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.present(actionSheet, animated: true)
        
        
        debugPrint("leaving the game")
        
        
    }
    
    @objc func startGame(_ sender: UIButton) {
        
    }
    
    
    func displayPopup(forUser: User, index: IndexPath) {
        let pop = InfoController()
        pop.image = forUser.profilePic
        debugPrint(forUser.fullname)
        pop.titleText = forUser.fullname
        pop.detailText = "@" + forUser.username
        
        if forUser != game.admin {
            pop.actionText = "Remove From Game"
            pop.actionCallback = {
                FirebaseAPIClient.gameLeft(by: forUser, fromGame: self.game, success: {
                    self.tableView.reloadData()
                }, fail: {})
            }
        }
        
        
        pop.finalCallback = {
            self.tableView.deselectRow(at: index, animated: true)
        }
        
        pop.presentIn(view: self.view)
    }
    
    
    


}