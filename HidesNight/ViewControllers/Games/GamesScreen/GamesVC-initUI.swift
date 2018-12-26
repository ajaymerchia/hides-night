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
        initNewGameButton()
    }

    // UI Initialization Helpers
    
    // Navigation
    func initNav() {
        self.title = "Games"
        guard let nav = self.navigationController?.navigationBar else {
            return
        }
        nav.tintColor = .white
        
        nav.titleTextAttributes = [NSAttributedString.Key.font: UIFont.HEADER_FONT!, NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navbar = nav
        
        let imgToUse = user.profilePic ?? .avatar_alpha
        // Ideal Button Formatting
        profilePictureButton = UIButton(frame: CGRect(x: 15, y: 0, width: 32, height: 32))
        profilePictureButton.setImage(imgToUse, for: .normal)
        profilePictureButton.imageView?.contentMode = .scaleAspectFill
        
        profilePictureButton.imageView?.layer.cornerRadius = 0.5 * profilePictureButton.frame.width
        profilePictureButton.imageView?.layer.borderWidth = 0.75
        profilePictureButton.imageView?.layer.borderColor = rgba(240,240,240,1).cgColor
        
        profilePictureButton.addTarget(self, action: #selector(goToProfile), for: .touchUpInside)
        nav.addSubview(profilePictureButton)
        profilePictureButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profilePictureButton.leftAnchor.constraint(equalTo: nav.leftAnchor, constant: 20),
            profilePictureButton.bottomAnchor.constraint(equalTo: nav.bottomAnchor, constant: -6),
            profilePictureButton.heightAnchor.constraint(equalToConstant: 32),
            profilePictureButton.widthAnchor.constraint(equalToConstant: 32)
        ])
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
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: UIRectEdge.left)
        
    }

    // Game Creation
    func initNewGameButton() {
        newGameButton = UIButton(frame: LayoutManager.belowCentered(elementAbove: navbar, padding: -.PADDING, width: view.frame.width - 4 * .PADDING, height: 50))
        newGameButton.setBackgroundColor(color: .ACCENT_GREEN, forState: .normal)
        newGameButton.layer.cornerRadius = 10
        newGameButton.clipsToBounds = true
        
        newGameButton.setTitle("Create New Game", for: .normal)
        newGameButton.setTitleColor(.black, for: .normal)
        newGameButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        newGameButton.titleLabel?.font = .SUBTITLE_FONT
        newGameButton.addTarget(self, action: #selector(goToCreateGame), for: .touchUpInside)
        
        
        view.addSubview(newGameButton)
    }
    
}
