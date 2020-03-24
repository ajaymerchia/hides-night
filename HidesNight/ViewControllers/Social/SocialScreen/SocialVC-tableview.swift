//
//  SocialVC-tableview.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/25/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import ARMDevSuite

extension SocialVC: UITableViewDelegate, UITableViewDataSource {
    func provideHeightFor(indexPath: IndexPath) -> CGFloat {
        if getTableDataFor(section: sectionsToDisplay[indexPath.section]) is [Game] {
            return 80
        }
        return 60
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        header.backgroundColor = UIColor(hexString: "1F2124")
        
        let label = UILabel(frame: CGRect(x: .PADDING, y: 0, width: view.frame.width, height: 30))
    
        label.text = self.sectionsToDisplay[section]
        label.font = .HEADER_FONT
        label.textColor = .ACCENT_BLUE
        header.addSubview(label)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return provideHeightFor(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let data = getTableDataFor(section: sectionsToDisplay[section])
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = getTableDataFor(section: sectionsToDisplay[indexPath.section])
        if let users = data as? [User] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonCell
            
            
            let cellUser = users[indexPath.row]
            // Initialize Cell
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            cell.awakeFromNib()
            cell.selectionStyle = .none
            cell.initializeCellFrom(data: cellUser, size: CGSize(width: view.frame.width, height: provideHeightFor(indexPath: indexPath)))
            cell.setState(to: categorize(usr: cellUser))
            if let img = cellUser.profilePic {
                cell.profilePic.setImage(img, for: .normal)

            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") as! GameCell
            
            guard let games = data as? [Game] else {return cell}
            let game = games[indexPath.row]
            
            // Initialize Cell
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            cell.awakeFromNib()
            cell.selectionStyle = .none
            cell.initializeCellFrom(data: game, size: CGSize(width: tableView.frame.width, height: 80))
            
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let thisHeader = self.sectionsToDisplay[indexPath.section]
        
        if let selection = getTableDataFor(section: thisHeader)[indexPath.row] as? User {
            guard selection != self.user else {
                return
            }
            self.friendSelected = selection
            self.selectedIsRequest = (thisHeader != SocialVC.headerNames[2])
            self.performSegue(withIdentifier: "social2friendDetail", sender: self)
        }
        
        if let selection = getTableDataFor(section: thisHeader)[indexPath.row] as? Game {
            self.gameSelected = selection
            self.selectedIsRequest = (thisHeader != SocialVC.headerNames[2])
            self.performSegue(withIdentifier: "social2gameDetail", sender: self)
        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if originalContentPosition == nil {
            originalContentPosition = scrollView.contentOffset.y
        }
        scrollView.bounces = (scrollView.contentOffset.y >= originalContentPosition);
        if scrollView.contentOffset.y < originalContentPosition {
            scrollView.setContentOffset(CGPoint(x: 0, y: originalContentPosition), animated: false)
        }
    }

    
}
