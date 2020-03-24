//
//  CreateGameVC-tableview.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/25/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import ARMDevSuite
import UIKit

extension CreateGameVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return allCells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return allCells[indexPath.section][indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightComputer(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let ret = UIView(frame: CGRect.zero)
            ret.backgroundColor = .black
            return ret
        }
        
        let ret = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        ret.backgroundColor = .clear
        return ret
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisCell = allCells[indexPath.section][indexPath.row]
        thisCell.layer.shadowOpacity = 0
        thisCell.layer.masksToBounds = true
        
        if !(indexPath.section == 0 && indexPath.section == 0) {
            eventNameField.resignFirstResponder()
        }
        
        tableView.beginUpdates()
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                thisCell.contentView.backgroundColor = cellColor
            } else {
                thisCell.contentView.backgroundColor = .black
                tableView.deselectRow(at: indexPath, animated: true)
                self.performSegue(withIdentifier: "create2dateTime", sender: self)
            }
        } else if indexPath.section == 1 {
            thisCell.contentView.backgroundColor = cellColor
            activate(cell: thisCell, index: indexPath)
        } else {
            thisCell.contentView.backgroundColor = .black
            tableView.deselectRow(at: indexPath, animated: true)
            
            if indexPath.row == 0 {
                awaitingTeam = true
            } else {
                awaitingSeek = true
            }
            
            self.performSegue(withIdentifier: "create2decisionPicker", sender: self)
        }
        
        tableView.endUpdates()
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let thisCell = allCells[indexPath.section][indexPath.row]
        thisCell.layer.shadowOpacity = 0
        thisCell.layer.masksToBounds = true
        
        if (indexPath.section == 0 && indexPath.row == 0) || indexPath.section == 1 {
            thisCell.contentView.backgroundColor = cellColor
        } else {
            thisCell.contentView.backgroundColor = .black
        }
    }
    
    func heightComputer(indexPath: IndexPath) -> CGFloat {
        let thisCell = allCells[indexPath.section][indexPath.row]
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 60
            } else {
                return 40
            }
        } else if indexPath.section == 1 {
            if thisCell.isSelected {
                return 200
            }
            return 40
        } else {
            return 40
        }
    }
    
    
}
