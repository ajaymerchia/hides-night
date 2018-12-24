//
//  GamesVC-initUI.swift
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
    func initUI() {
        self.view.backgroundColor = .black
        initNav()
        initSidebar()
    }

    // UI Initialization Helpers
    func initNav() {
        self.title = "Games"
        guard let nav = self.navigationController?.navigationBar else {
            return
        }
        nav.tintColor = .white
        nav.backgroundColor = .black
        nav.barTintColor = .black
        
        nav.titleTextAttributes = [NSAttributedString.Key.font: UIFont.HEADER_FONT!, NSAttributedString.Key.foregroundColor: UIColor.white]
       
        
        let imgToUse = user.profilePic ?? .avatar_black
        // Ideal Button Formatting
        idealButton = UIButton(frame: CGRect(x: 15, y: 0, width: 32, height: 32))
        idealButton.setImage(imgToUse, for: .normal)
        idealButton.imageView?.contentMode = .scaleAspectFill
        
        idealButton.imageView?.layer.cornerRadius = 0.5 * idealButton.frame.width
        idealButton.imageView?.layer.borderWidth = 0.75
        idealButton.imageView?.layer.borderColor = rgba(240,240,240,1).cgColor
        
        idealButton.addTarget(self, action: #selector(goToProfile), for: .touchUpInside)
        nav.addSubview(idealButton)
        idealButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            idealButton.leftAnchor.constraint(equalTo: nav.leftAnchor, constant: 20),
            idealButton.bottomAnchor.constraint(equalTo: nav.bottomAnchor, constant: -6),
            idealButton.heightAnchor.constraint(equalToConstant: 32),
            idealButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc func updateImage(_ notification: Notification) {
        if let data = notification.userInfo as? [String: UIImage] {
            idealButton.setImage(data["img"]!, for: .normal)
        }
    }
    
    func initSidebar() {
        let menuLeftNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuNav") as! UISideMenuNavigationController
        
        ((menuLeftNavigationController.viewControllers[0]) as! ProfileVC).user = self.user
        

        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuShadowColor = .DARK_BLUE
        SideMenuManager.default.menuShadowRadius = 20
        SideMenuManager.default.menuWidth = 0.625 * view.frame.width
        SideMenuManager.default.menuAnimationFadeStrength = 0.4
        
//        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: UIRectEdge.left)
        
    }

}
