//
//  FriendDetailVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/25/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension FriendDetailVC {
    func initUI() {
        initNav()
        self.view.backgroundColor = .DARK_BLUE
        initImage()
        initName()
        if self.pendingRequest {
            addRequestHandlerButton()
        } else {
            addRemoveFriendButton()
        }
    }

    // UI Initialization Helpers
    func initNav() {
        if let nav = self.navigationController?.navigationBar {
            nav.tintColor = .white
            nav.backgroundColor = .DARK_BLUE
            nav.barTintColor = .DARK_BLUE
            
            nav.titleTextAttributes = [NSAttributedString.Key.font: UIFont.HEADER_FONT!, NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.navbar = nav
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(goBack))
        
        self.navigationItem.title = self.friend.fullname
    }
    
    func initImage() {
        let number = ((abs(CGFloat(self.friend.uid.hashValue))/pow(2,63)) * 180 * 10).truncatingRemainder(dividingBy: 180)
        let initals: String = String(friend.first.uppercased().prefix(1)) + String(friend.last.uppercased().prefix(1))
        
        profilePictureButton = UIButton(frame: LayoutManager.belowCentered(elementAbove: navbar, padding: .PADDING * 3, width: view.frame.width/2, height: view.frame.width/2))
        profilePictureButton.setTitle(initals, for: .normal)
        profilePictureButton.setTitleColor(.white, for: .normal)
        profilePictureButton.titleLabel?.font = UIFont.HEADER_FONT
        profilePictureButton.setBackgroundColor(color: UIColor.ACCENT_RED.modified(withAdditionalHue: number, additionalSaturation: 0, additionalBrightness: 0), forState: .normal)
        
        profilePictureButton.imageView?.contentMode = .scaleAspectFill
        profilePictureButton.layer.cornerRadius = profilePictureButton.frame.width/2
        profilePictureButton.clipsToBounds = true
        if let img = self.friend.profilePic {
            profilePictureButton.setImage(img, for: .normal)
        }
        view.addSubview(profilePictureButton)
    }

    func initName() {
        name = UILabel(frame: LayoutManager.belowCentered(elementAbove: profilePictureButton, padding: .PADDING, width: view.frame.width-40, height: 80))
        name.textAlignment = .center
        name.font = .TITLE_FONT
        name.textColor = .white
        name.text = friend.fullname
        name.adjustsFontSizeToFitWidth = true
        
        view.addSubview(name)
        view.addSubview(UISuite.getBorder(forView: name, thickness: 1.5, color: .white, side: .Bottom))
    }
    
    func addRemoveFriendButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.nav_remove_person.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(proposeEndOfFriendship))
        
    }
    
    func addRequestHandlerButton() {
        
        let wireButton = true
        let invertible = true
        let inset:CGFloat = 15
        
        accept = UIButton(frame: LayoutManager.belowCentered(elementAbove: name, padding: .PADDING * 2, width: view.frame.width/3, height: view.frame.width/3))
        accept.center = CGPoint(x: view.frame.width/4, y: (view.frame.height+name.frame.maxY)/2)
        accept.setBackgroundColor(color: .ACCENT_GREEN, forState: .normal)
        
        accept.setImage(UIImage.mark_check.withRenderingMode(.alwaysTemplate), for: .normal)
        accept.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        accept.imageView?.contentMode = .scaleAspectFit
        accept.imageView?.tintColor = .DARK_BLUE
        
        accept.layer.cornerRadius = accept.frame.width/2
        accept.clipsToBounds = true
        

        view.addSubview(accept)
        
        decline = UIButton(frame: LayoutManager.belowCentered(elementAbove: name, padding: .PADDING * 2, width: view.frame.width/3, height: view.frame.width/3))
        decline.center = CGPoint(x: view.frame.width*3/4, y: accept.frame.midY)
        decline.setBackgroundColor(color: .ACCENT_RED, forState: .normal)
        
        decline.setImage(UIImage.mark_cancel.withRenderingMode(.alwaysTemplate), for: .normal)
        decline.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        decline.imageView?.contentMode = .scaleAspectFit
        decline.imageView?.tintColor = .DARK_BLUE
        
        decline.layer.cornerRadius = decline.frame.width/2
        decline.clipsToBounds = true
        
        
        // Alternate Form
        if wireButton {
            accept.imageView?.tintColor = .ACCENT_GREEN
            accept.layer.borderColor = UIColor.ACCENT_GREEN.cgColor
            accept.layer.borderWidth = 1.5
            accept.setBackgroundColor(color: .clear, forState: .normal)
            
            
            decline.imageView?.tintColor = .ACCENT_RED
            decline.layer.borderColor = UIColor.ACCENT_RED.cgColor
            decline.layer.borderWidth = 1.5
            decline.setBackgroundColor(color: .clear, forState: .normal)
            
            if invertible {
                accept.setBackgroundColor(color: .ACCENT_GREEN, forState: .highlighted)
                decline.setBackgroundColor(color: .ACCENT_RED, forState: .highlighted)
                
                accept.addTarget(self, action: #selector(imageViewInvisible), for: .touchDown)
                decline.addTarget(self, action: #selector(imageViewInvisible), for: .touchDown)
                
                accept.addTarget(self, action: #selector(acceptFriendRequest(_:)), for: .touchUpInside)
                decline.addTarget(self, action: #selector(declineFriendRequest(_:)), for: .touchUpInside)
            }
            
        }
        

        view.addSubview(decline)
    }
    
    @objc func imageViewInvisible(_ sender: UIButton) {
        sender.imageView?.tintColor = self.view.backgroundColor
    }
    
    @objc func imageViewVisible(_ sender: UIButton) {
        sender.imageView?.tintColor = UIColor(cgColor: sender.layer.borderColor!)
    }
    
}
