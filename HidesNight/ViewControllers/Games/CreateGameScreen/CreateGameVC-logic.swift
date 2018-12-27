//
//  CreateGameVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension CreateGameVC {
    func getData() {
        self.admin = (self.navigationController as! DataNavVC).user
    }
    
    @objc func requestEventImage() {
        let actionSheet = UIAlertController(title: "Select Event Photo From", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .photoLibrary)
        }))
        
        if self.eventImageHeader.image != nil {
            actionSheet.addAction(UIAlertAction(title: "Remove Current Photo", style: .destructive, handler: { (action) -> Void in
                // Animate the Top UIView away
                self.removeEventPhoto()
            }))
        }
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = addImageButton
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.present(actionSheet, animated: true)
    }
    
    func animateInHeader(img: UIImage) {
        UIView.animate(withDuration: 1) {
            self.tableview.beginUpdates()
            self.eventImageHeader.image = img
            self.tableview.tableHeaderView = self.eventImageHeader
            self.tableview.endUpdates()
        }
    }
    
    func removeEventPhoto() {
        UIView.animate(withDuration: 1) {
            self.tableview.beginUpdates()
            self.eventImageHeader.image = nil
            self.tableview.tableHeaderView = nil
            self.tableview.endUpdates()
        }
    }
    
    func ind(_ section: Int, _ row: Int) -> IndexPath {
        return IndexPath(item: row, section: section)
    }
    
    func update(label: UILabel, withInterval: TimeInterval) {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        let now = Date()
        let formattedTimeLeft = formatter.string(from: now, to: Date(timeInterval: withInterval, since: now))
        
        label.text = formattedTimeLeft
    }
    
    func activate(cell: UITableViewCell, index: IndexPath) {
        durationPickers[index.row].alpha = 1
        
        switch index.row {
        case 1:
            for borders in allBorders {
                borders[0].alpha = 0
                borders[1].alpha = 0
            }
            allBorders[0][1].alpha = 1
            allBorders[2][0].alpha = 1
            
        case 2:
            // make all bottom visible
            for borders in allBorders {
                borders[0].alpha = 0
                borders[1].alpha = 1
            }
        default:
            // make all top visible
            for borders in allBorders {
                borders[0].alpha = 1
                borders[1].alpha = 0
            }
        }
        
    }
    
    func deactivate(cell: UITableViewCell, index: IndexPath) {
        durationPickers[index.row].removeFromSuperview()
    }
    
    @objc func durationDidChange(_ sender: UIDatePicker) {
        
        if sender.tag == 0 {
            self.roundDuration = sender.countDownDuration
            self.checkInDuration = min(self.checkInDuration, self.roundDuration)
            self.gpsActivation = min(self.gpsActivation, self.roundDuration)
            
            debugPrint(roundDuration, checkInDuration, gpsActivation)
            
            update(label: labels[0], withInterval: self.roundDuration)
            update(label: labels[1], withInterval: self.checkInDuration)
            update(label: labels[2], withInterval: self.gpsActivation)
            durationPickers[1].countDownDuration = self.checkInDuration
            durationPickers[2].countDownDuration = self.gpsActivation
        } else if sender.tag == 1{
            
            self.checkInDuration = min(sender.countDownDuration, self.roundDuration)
            update(label: labels[1], withInterval: self.checkInDuration)
            durationPickers[1].countDownDuration = self.checkInDuration
        } else {
            self.gpsActivation = min(sender.countDownDuration, self.roundDuration)
            update(label: labels[2], withInterval: self.gpsActivation)
            durationPickers[2].countDownDuration = self.gpsActivation
        }
        
        
    }


}
