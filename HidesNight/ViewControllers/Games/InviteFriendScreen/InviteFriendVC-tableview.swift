//
//  InviteFriendsVC-tableview.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers

extension InviteFriendVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func provideHeightFor(indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && invitesToSend.count != 0 {
            return invitesToSend.count
        } else {
            if searchBox.text == "" {
                return self.friendsToShow.count
            } else {
                return self.searchResults.count + 1
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if invitesToSend.count == 0 || self.friendsToShow.count == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return provideHeightFor(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        header.backgroundColor = UIColor.flatBlackDark.darkerColor(percent: 0.45)
        
        let label = UILabel(frame: CGRect(x: .PADDING, y: 0, width: view.frame.width, height: 30))
        
        
        if section == 0 && invitesToSend.count != 0 {
            label.text = "Selected"
        } else {
            if searchBox.text == "" {
                label.text = "Friends"
            } else {
                label.text = "Results"
            }
        }
        label.font = .HEADER_FONT
        label.textColor = .ACCENT_BLUE
        header.addSubview(label)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        var tempUser: User? = nil
        var adjustString = false
        if indexPath.section == 0 && invitesToSend.count != 0 {
            tempUser = invitesToSend[indexPath.row]
        } else {
            if searchBox.text == "" {
                tempUser = self.friendsToShow[indexPath.row]
            } else {
                if indexPath.row == 0 {
                    tempUser = User.createTemporaryUser(first: searchBox.text!)
                    adjustString = true
                } else {
                    tempUser = self.searchResults[indexPath.row-1]
                    
                }
                
                
            }
        }
        
        guard let cellUser = tempUser else {
            return cell
        }
        // Initialize Cell
        cell.awakeFromNib()
        cell.initializeCellFrom(data: cellUser, size: CGSize(width: view.frame.width, height: provideHeightFor(indexPath: indexPath)))
        cell.profilePic.setImage(cellUser.profilePic, for: .normal)
        
        if cellUser == self.user {
            cell.setState(to: .currUser)
        } else if invitesToSend.contains(cellUser) {
            cell.setState(to: .selected)
        } else {
            cell.setState(to: .existing)
        }
        
        if adjustString {
            cell.name.text = "Manually Add \"\(cellUser.first!)\""
            cell.setState(to: .unknown)
        }
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && invitesToSend.count != 0 {
            // Deselect
            let friend = self.invitesToSend.remove(at: indexPath.row)
            
            if !friend.uid.starts(with: "temp") {
                self.friendsToShow.append(friend)
            }
            
            
            self.invitesToSend.sort()
            self.friendsToShow.sort()
            
        } else {
            if searchBox.text == "" {
                // Select From Friends List
                let newlySelected = self.friendsToShow.remove(at: indexPath.row)
                self.invitesToSend.append(newlySelected)
                
                self.invitesToSend.sort()
                self.friendsToShow.sort()
            } else {
                // Select From Search Results
                if indexPath.row == 0 {
                    let newlySelected = User.createTemporaryUser(first: searchBox.text!)
                    self.invitesToSend.append(newlySelected)

                } else {
                    let newlySelected = self.searchResults.remove(at: indexPath.row - 1)
                    self.invitesToSend.append(newlySelected)
                    if let otherArrInd = self.friendsToShow.index(of: newlySelected) {
                        self.friendsToShow.remove(at: otherArrInd
                        )
                    }
                    
                }
                
                
                self.invitesToSend.sort()
                self.searchResults.sort()
            }
        }
        tableview.reloadData()

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
