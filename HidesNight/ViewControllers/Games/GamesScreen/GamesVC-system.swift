//
//  GamesVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/22/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite
import SideMenu


extension GamesVC {
    func setupManagers() {
//        alerts = AlertManager(view: self, stateRestoration: {
//
//        })
        
        setUpChangeListener()
        NotificationCenter.default.addObserver(self, selector: #selector(updateImage(_ :)), name: .newImage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openGame(_:)), name: .openGame, object: nil)
        
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
        if !firstLoad {
            sortAndDisplayGames()
            
        } else {
            firstLoad = false
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.profilePictureButton.alpha = 0
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dataNav = segue.destination as? DataNavVC {
            dataNav.user = self.user
        } else if let detail = segue.destination as? GameDetailVC {
            detail.game = gameToDetail
            detail.user = self.user
        } else if let active = segue.destination as? ActiveGameVC {
            active.game = gameToDetail
            active.user = self.user
        }
    }

    // Segue Out Functions
    @objc func goToProfile() {
        self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func goToCreateGame() {
        self.performSegue(withIdentifier: "games2create", sender: self)
    }
    
    @objc func openGame(_ notification: Notification) {
        guard let data = notification.userInfo as? [String: String] else {
            return
        }
        guard let gameID = data["game"] else {
            return
        }
        
        for game in self.user.games {
            if game.uid == gameID {
                self.gameToDetail = game
            }
        }
        
        FirebaseAPIClient.updateGame(self.gameToDetail) {
            self.sortAndDisplayGames()
            self.performSegue(withIdentifier: "games2active", sender: self)
        }
        
    }
    

}
