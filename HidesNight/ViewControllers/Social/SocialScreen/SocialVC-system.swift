//
//  SocialVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite
import SideMenu

extension SocialVC {
    func setupManagers() {
		alerts = AlertManager(vc: self, defaultHandler: {
            self.alerts.jghud?.dismiss()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(updateImage(_ :)), name: .newImage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showFriendRequest(_:)), name: .viewFriendRequest, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(acceptFriendRequest(_:)), name: .acceptFriendRequest, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rejectFriendRequest(_:)), name: .rejectFriendRequest, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showGameRequest(_:)), name: .viewGameRequest, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(acceptGameRequest(_:)), name: .acceptGameRequest, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rejectGameRequest(_:)), name: .rejectGameRequest, object: nil)
        
        
        
        
        
    }
    
    @objc func updateImage(_ notification: Notification) {
        if let data = notification.userInfo as? [String: UIImage] {
            profilePictureButton.setImage(data["img"]!, for: .normal)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.profilePictureButton.alpha = 1
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if self.sectionsToDisplay.count == 0 {
            alerts.startProgressHud(withMsg: "Loading Friends", style: .dark)
            loadFriendsAndInvites()
        } else {
            FirebaseAPIClient.updateLocalUserData(usr: self.user) {
                self.loadFriendsAndInvites()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.profilePictureButton.alpha = 0
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navVC = segue.destination as? DataNavVC {
            navVC.user = self.user
            if segue.identifier == "social2friendDetail" {
                navVC.user2 = self.friendSelected
                navVC.isRequest = self.selectedIsRequest
            }
        } else if let gameVC = segue.destination as? GameDetailVC {
            gameVC.user = self.user
            gameVC.game = self.gameSelected
        }
    }

    // Segue Out Functions
    @objc func goToProfile() {
        self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func goToAddFriend() {
        self.performSegue(withIdentifier: "go2AddFriend", sender: self)

//		self.launchAddFriend()
    }
	func launchAddFriend() {
//		self.present(UINavigationController(rootViewController: .init()), animated: true, completion: nil)
//
//		return
		let vc = AddFriendVC()
		AddFriendVC.user = self.user
		vc.view.backgroundColor = .white
		let n = DataNavVC(rootViewController: vc)
		n.user = self.user
		n.modalPresentationStyle = .fullScreen
		n.view.backgroundColor = .white
		self.present(n, animated: true, completion: nil)
		
//		do {
//			self.present(vc, animated: true, completion: nil)
//			self.navigationController?.pushViewController(vc, animated: true)
//		} catch {
//			print(error.localizedDescription)
//		}
		
//		self.present(DataNavVC(rootViewController: .init()), animated: true, completion: nil)
	}
    
    
    // Notification Processors
    func getFriendFromNotification(_ notification: Notification) -> (User, Bool)? {
        guard let data = notification.userInfo as? [String: String] else {
            return nil
        }
        
        guard let friendID = data["friend"] else {
            return nil
        }
        
        guard let requests = tableData[1] as? [User] else {
            return nil
        }
        
        for user in requests {
            if user == friendID {
                return (user, true)
            }
        }
        
        guard let friends = tableData[2] as? [User] else {
            return nil
        }
        for user in friends {
            if user == friendID {
                return (user, false)
            }
        }
        
        
        return nil
    }
    
    func performUpdate(completion: @escaping () -> ()) {
        FirebaseAPIClient.updateLocalUserData(usr: self.user) {
            self.loadFriendsAndInvites({
                completion()
            })
        }
    }
    
    @objc func showFriendRequest(_ notification: Notification) {
        performUpdate {
            if let usr = self.getFriendFromNotification(notification) {
                self.friendSelected = usr.0
                self.selectedIsRequest = usr.1
                self.performSegue(withIdentifier: "social2friendDetail", sender: self)
            }
        }
    }
    
    @objc func acceptFriendRequest(_ notification: Notification) {
        performUpdate {
            if let usr = self.getFriendFromNotification(notification) {
                FirebaseAPIClient.acceptFriendRequest(from: usr.0, to: self.user) {
                    self.loadFriendsAndInvites()
                }
            }
        }
    }
    
    @objc func rejectFriendRequest(_ notification: Notification) {
        performUpdate {
            if let usr = self.getFriendFromNotification(notification) {
                FirebaseAPIClient.rejectFriendRequest(from: usr.0, to: self.user) {
                    self.loadFriendsAndInvites()
                }
            }
        }
    }
    
    
    func getGameFromNotification(_ notification: Notification) -> (Game, Bool)? {
        guard let data = notification.userInfo as? [String: String] else {
            return nil
        }
        
        guard let gameID = data["gameID"] else {
            return nil
        }
        
        guard let requests = tableData[0] as? [Game] else {
            return nil
        }
        
        for game in requests {
            if game.uid == gameID {
                return (game, true)
            }
        }
        
        return nil
    }
    
    @objc func showGameRequest(_ notification: Notification) {
        self.view.isUserInteractionEnabled = false
        alerts.startJGProgressHud(withTitle: "Loading Game...", style: .dark)
        performUpdate {
            if let game = self.getGameFromNotification(notification) {
                self.gameSelected = game.0
                self.selectedIsRequest = game.1
                self.view.isUserInteractionEnabled = true
                self.alerts.jghud?.dismiss()
                self.performSegue(withIdentifier: "social2gameDetail", sender: self)
            }
        }
    }
    
    @objc func acceptGameRequest(_ notification: Notification) {
        self.view.isUserInteractionEnabled = false
        alerts.startJGProgressHud(withTitle: "Accepting Game Invitation...", style: .dark)
        performUpdate {
            if let game = self.getGameFromNotification(notification) {
                FirebaseAPIClient.gameInvitationAccepted(by: self.user, forGame: game.0, success: {
                    self.loadFriendsAndInvites {
                        self.friendsTable.reloadData()
                        self.alerts.jghud?.dismiss()
                        self.view.isUserInteractionEnabled = true
                        self.tabBarController?.selectedIndex = 0
                        
                    }
                    
                }, fail: {})
            }
        }
    }
    
    @objc func rejectGameRequest(_ notification: Notification) {
        self.view.isUserInteractionEnabled = false
        alerts.startJGProgressHud(withTitle: "Rejecting Game Invitation...", style: .dark)
        performUpdate {
            if let game = self.getGameFromNotification(notification) {
                FirebaseAPIClient.gameInvitationRejected(by: self.user, forGame: game.0, success: {
                    self.loadFriendsAndInvites {
                        self.friendsTable.reloadData()
						self.alerts.jghud?.dismiss()
                        self.view.isUserInteractionEnabled = true
                    }
                }, fail: {})
            }
        }
    }

    
    

}
