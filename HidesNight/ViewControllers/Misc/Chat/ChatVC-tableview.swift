//
//  ChatVC-tableview.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/7/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadChats()
        return pureMessages.count
    }
    
    func messageRequiresHeader(index: Int) -> Bool {
        let currentMessage = pureMessages[index]
        let previousMessage = index == pureMessages.count - 1 ? nil : pureMessages[index + 1]
     
        
        return currentMessage.senderID != self.user.uid && (previousMessage == nil || previousMessage?.senderID != currentMessage.senderID)

        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30 // Inverted top padding for tableview
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func heightComputer(index: Int) -> CGFloat {

        if let img = pureMessages[index].img {
            let imgSize = img.size
            
            let maxWidth = view.frame.width * 0.75
            let maxHeight = view.frame.width/2
            
            let aspectRatio = imgSize.height/imgSize.width
        
            
            return min(maxWidth * aspectRatio, maxHeight) + (messageRequiresHeader(index: index) ? 15 : 0)
        }
        
        var numRows: CGFloat = 1
        if let message = pureMessages[index].msg {
            numRows = CGFloat(ceil(Double(message.count) / 30))
        }
        
        return 20 + 20 * numRows + (messageRequiresHeader(index: index) ? 15 : 0)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightComputer(index: indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        cell.selectionStyle = .none
        
        let currentMessage = pureMessages[indexPath.row]
        
        var targetWidth = view.frame.width
        
        if currentMessage.imgPending {
            currentMessage.imageLoaded = {
                tableView.reloadData()
            }
        }
        
        if let img = currentMessage.img {
            targetWidth = img.size.width/img.size.height * heightComputer(index: indexPath.row)
        }
    
        cell.masterWidth = tableView.frame.width
        cell.initializeCellFrom(data: currentMessage, size: CGSize(width: targetWidth, height: heightComputer(index: indexPath.row)), forPerspective: self.user, inGame: self.game, withHeader: messageRequiresHeader(index: indexPath.row))

        
        
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedImage = self.pureMessages[indexPath.row].img {
            imageTapped(img: selectedImage)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    


}
