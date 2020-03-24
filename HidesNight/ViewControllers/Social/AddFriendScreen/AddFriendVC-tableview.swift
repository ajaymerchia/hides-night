//
//  AddFriendVC-tableview.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import ARMDevSuite

extension AddFriendVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func provideHeightFor(indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsToDisplay.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
		header.backgroundColor = UIColor.flatBlackDark().darken(byPercentage: 0.45)
        
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
        return self.compiledResults[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonCell        
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let cellUser = self.compiledResults[indexPath.section][indexPath.row]
        // Initialize Cell
        cell.awakeFromNib()
        cell.initializeCellFrom(data: cellUser, size: CGSize(width: view.frame.width, height: provideHeightFor(indexPath: indexPath)))
        cell.setState(to: categorize(usr: cellUser))
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.sectionsToDisplay[indexPath.section] {
        case "Selected":
            // Deselect
            let userToRemove = self.requestsToDisplay[indexPath.row]
            guard let userIndex = self.requestsToSend.index(of: userToRemove) else {return}
            self.requestsToSend.remove(at: userIndex)
            filterResults()
        case "People":
            // Select
            self.requestsToSend.append(self.searchResults[indexPath.row])
            filterResults()
        default:
            return
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
        searchBox.resignFirstResponder()
        
    }
    
    
}
