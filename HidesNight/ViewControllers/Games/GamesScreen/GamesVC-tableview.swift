//
//  GamesVC-tableview.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/27/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers

extension GamesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getGamesForUI(indexPath: IndexPath(row: 0, section: section)).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
//        header.backgroundColor = UIColor(hexString: "1F2124")
        header.backgroundColor = .black
        
        let label = UILabel(frame: CGRect(x: .PADDING, y: 5, width: view.frame.width, height: 30))
        
        label.text = self.sectionsToDisplay[section]
        label.font = .HEADER_FONT
        label.textColor = .ACCENT_BLUE
        header.addSubview(label)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") as! GameCell
        
        // Initialize Cell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        cell.selectionStyle = .none
        cell.initializeCellFrom(data: getGameForUI(indexPath: indexPath), size: CGSize(width: tableView.frame.width, height: 80))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        gameToDetail = getGameForUI(indexPath: indexPath)
        
        if sectionsToDisplay[indexPath.section] == GamesVC.possibleHeaders[0] {
            self.performSegue(withIdentifier: "games2active", sender: self)
        } else {
            self.performSegue(withIdentifier: "games2detail", sender: self)
        }
        
    }
    
    
}
