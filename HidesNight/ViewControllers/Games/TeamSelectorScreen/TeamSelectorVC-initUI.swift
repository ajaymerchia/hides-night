//
//  TeamSelectorVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension TeamSelectorVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func initUI() {
        self.view.backgroundColor = .black
        self.title = "Pick a Team"
        initTableView()
    }
    
    // UI Initialization Helpers
    func initTableView() {
        tableview = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (self.tabBarController?.tabBar.frame.height)!))
        tableview.register(GameCell.self, forCellReuseIdentifier: "teamCell")
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .black
        tableview.separatorStyle = .none
        
        tableview.showsVerticalScrollIndicator = false
        
        view.addSubview(tableview)
    }
    
    func teamFor(indexPath: IndexPath) -> Team {
        return self.explictTeamList?[indexPath.row] ?? self.game.teams.values.sorted()[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callback(teamFor(indexPath: indexPath))
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return explictTeamList?.count ?? self.game.teams.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell") as! GameCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let team = teamFor(indexPath: indexPath)
        
        cell.awakeFromNib()
        cell.initializeCellFrom(data: team, size: CGSize(width: view.frame.width, height: 70))
        cell.selectionStyle = .none
        return cell
    }
    
    
}
