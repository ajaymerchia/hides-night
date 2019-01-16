//
//  InviteFriendVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/28/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension InviteFriendVC {
    func initUI() {
        self.view.backgroundColor = .black
        initNav()
        initSearch()
        initTableView()
    }

    // UI Initialization Helpers
    @objc func initNav() {
        if let nav = self.navigationController?.navigationBar {
            nav.tintColor = .white
            nav.backgroundColor = .black
            nav.barTintColor = .black
            
            nav.titleTextAttributes = [NSAttributedString.Key.font: UIFont.HEADER_FONT!, NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.navbar = nav
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
//        self.navigationItem.titleView = searchBox
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invite", style: .done, target: self, action: #selector(inviteFriends))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.TEXT_FONT!,
                                                                        NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.TEXT_FONT!,
                                                                        NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
    func initSearch() {
        searchBox = UITextField(frame: LayoutManager.belowCentered(elementAbove: navbar, padding: navbar.frame.height, width: view.frame.width - 2 * .PADDING, height: 40))
        searchBox.textColor = .white
        searchBox.tintColor = .white
        searchBox.font = .TEXT_FONT
        searchBox.attributedPlaceholder = NSAttributedString(string: "Search for Friends",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.flatWhiteDark])
        searchBox.returnKeyType = .done
        searchBox.keyboardToolbar.isHidden = true
        searchBox.addTarget(self, action: #selector(inviteFriends), for: .editingDidEndOnExit)

        searchBox.addTarget(self, action: #selector(runFilter), for: .editingChanged)
        
        view.addSubview(searchBox)
    }
    
    func initTableView() {
        tableview = UITableView(frame: LayoutManager.belowCentered(elementAbove: searchBox, padding: 0, width: view.frame.width, height: view.frame.height - navbar.frame.maxY))
        tableview.register(PersonCell.self, forCellReuseIdentifier: "personCell")
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .flatBlack
        tableview.separatorStyle = .none
        
        tableview.showsVerticalScrollIndicator = false
        
        view.addSubview(tableview)
        
    }
    
    

}
