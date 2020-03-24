//
//  ChatVC-textfield.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/6/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension ChatVC: UITextFieldDelegate {
    @objc func messageBoxTyped() {
        sendButton.isEnabled = (composeTextField.text != "") || photoSelected() != nil
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame!.origin.y 
            
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0
            
            UIView.animate(withDuration: duration) {
                self.composeBar.frame.origin = CGPoint(x: 0, y: endFrameY - self.textfieldOffset)
                self.chatView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.composeBar.frame.minY)
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTextMessage()
        return true
    }
    
}
