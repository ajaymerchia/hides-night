//
//  ActiveGameVC-tableview.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/9/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers
import CountdownLabel

extension ActiveGameVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSegSelected == 0 {
            if round.roundStatus == .hiding {
                return 2
            } else {
                return 3
            }
            
        } else {
            return self.game.teams.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightComputer()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentSegSelected == 0 {
            var cell = countdownCells[0]
            
            if round.roundStatus == .hiding {
                cell = countdownCells[indexPath.row == 0 ? 0 : 3]
                
            } else {
                cell = countdownCells[indexPath.row + 1]
            }
            
            
            if round.roundIsActive {
                cell.countdown.start()
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell") as! GameCell
            
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }

            cell.awakeFromNib()
            
            let team = teamFor(indexPath: indexPath)
            cell.initializeCellFrom(data: team, size: CGSize(width: view.frame.width, height: heightComputer()))
            
            
            var statusText = isSeeker(team) ? "Seeker" : "Hiding"
            cell.status.textColor = .ACCENT_BLUE
            
            
            if let timeSinceCheck = self.round.teamCheckins[team.uid]?.timeIntervalSinceNow {
                let minutesPassed: Int = Int(timeSinceCheck.magnitude) / 60
                
                let tense = minutesPassed == 1 ? "" : "s"
                let addition = minutesPassed == 0 ? ", last checkin: now" : ", last checkin: \(minutesPassed) minute"+tense+" ago"
                statusText += addition
                
                if minutesPassed * 60 >= Int(self.game.checkInDuration.magnitude) {
                    cell.status.textColor = .ACCENT_RED
                }
            } else {
                statusText += ", has not checked in"
                cell.status.textColor = .ACCENT_RED

            }
            
            cell.status.text = statusText
            
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentSegSelected == 0 {
            return
        } else {
            self.teamToShow = teamFor(indexPath: indexPath)
            self.performSegue(withIdentifier: "active2Team", sender: self)
        }
    }
    
    
    func heightComputer() -> CGFloat {
        if currentSegSelected == 0 {
            return 80
        } else {
            return 70
        }
    }
    
    func teamFor(indexPath: IndexPath) -> Team {
        return self.game.teams.values.sorted()[indexPath.row]
    }
    
    func isSeeker(_ team: Team) -> Bool {
        return self.round.teamsCaught.keys.contains(team.uid) || team == self.round.seeker
    }

}

extension ActiveGameVC: CountdownLabelDelegate {
    func countdownFinished() {
        self.updateUIComponents()
    }
}
