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
import iosManagers
import SideMenu


extension GamesVC {
    func setupManagers() {
//        alerts = AlertManager(view: self, stateRestoration: {
//
//        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateImage(_ :)), name: .newImage, object: nil)
    }
    
    @objc func updateImage(_ notification: Notification) {
        if let data = notification.userInfo as? [String: UIImage] {
            profilePictureButton.setImage(data["img"]!, for: .normal)
        }
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidAppear(_ animated: Bool) {

    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dataNav = segue.destination as? DataNavVC {
            dataNav.user = self.user
        }
    }

    // Segue Out Functions
    @objc func goToProfile() {
        self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func goToCreateGame() {
        self.performSegue(withIdentifier: "games2create", sender: self)
    }
    

}
