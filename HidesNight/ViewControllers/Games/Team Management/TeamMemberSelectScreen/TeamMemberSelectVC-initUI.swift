//
//  TeamMemberSelectVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/29/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension TeamMemberSelectVC: UITableViewDelegate, UITableViewDataSource {
    func initUI() {
        self.view.backgroundColor = .black
        self.title = "Pick a Member"
        initTableView()
    }

    // UI Initialization Helpers
    func initTableView() {
        tableview = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (self.tabBarController?.tabBar.frame.height)!))
        tableview.register(PersonCell.self, forCellReuseIdentifier: "personCell")
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .black
        tableview.separatorStyle = .none
        
        tableview.showsVerticalScrollIndicator = false
        
        view.addSubview(tableview)
    }

}
