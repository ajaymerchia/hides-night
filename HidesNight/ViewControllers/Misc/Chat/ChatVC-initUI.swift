//
//  ChatVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/6/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension ChatVC {
    func initUI() {
        self.view.backgroundColor = .black
        self.title = "Chat"
        
        navbarBottom = self.navigationController?.navigationBar.frame.height
        textfieldOffset = (navbarBottom!*2 + composeBarHeight)
        
        initInputControl()
        initTableview()
        keyboardRehandling()
    }

    
    func initInputControl() {
        let inset: CGFloat = 4

        composeBar = UIView(frame: CGRect(x: 0, y: view.frame.maxY - textfieldOffset, width: view.frame.width, height: composeBarHeight))

        let verticalIndent: CGFloat = .PADDING
        let itemHeight: CGFloat = composeBarHeight - 2 * verticalIndent

        addPhotoButton = UIButton(frame: CGRect(x: .PADDING, y: verticalIndent, width: itemHeight, height: itemHeight))
        addPhotoButton.setBackgroundColor(color: .clear, forState: .normal)
        addPhotoButton.setImage(UIImage.nav_add_image.withRenderingMode(.alwaysTemplate), for: .normal)
        addPhotoButton.imageView?.tintColor = .offWhite
        addPhotoButton.imageView?.contentMode = .scaleAspectFit
        addPhotoButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        addPhotoButton.clipsToBounds = true
        addPhotoButton.addTarget(self, action: #selector(requestImageMessage), for: .touchUpInside)


        let sendButtonWidth: CGFloat = 60
        sendButton = UIButton(frame: CGRect(x: view.frame.width - (sendButtonWidth + .PADDING), y: 0, width: sendButtonWidth, height: composeBar.frame.height))
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.TEXT_FONT
        sendButton.setTitleColor(.offWhite, for: .disabled)
        sendButton.setTitleColor(UIColor.ACCENT_BLUE, for: .normal)
        sendButton.isEnabled = false
        sendButton.addTarget(self, action: #selector(sendTextMessage), for: .touchUpInside)

        composeTextField = UITextField(frame: CGRect(x: addPhotoButton.frame.maxX + .MARGINAL_PADDING * 2, y: verticalIndent, width: (sendButton.frame.minX - addPhotoButton.frame.maxX - 3 * .MARGINAL_PADDING), height: itemHeight))
        composeTextField.attributedPlaceholder = NSAttributedString(string: "Aa", attributes: [NSAttributedString.Key.foregroundColor : UIColor.offWhite, NSAttributedString.Key.font: UIFont.TEXT_FONT!])
        composeTextField.font = .TEXT_FONT
        composeTextField.textColor = .white
        composeTextField.tintColor = .white
        composeTextField.backgroundColor = .flatBlack
        composeTextField.layer.cornerRadius = composeTextField.frame.height/2
        composeTextField.delegate = self
        composeTextField.returnKeyType = .send
        
        composeTextField.addTarget(self, action: #selector(messageBoxTyped), for: .allEditingEvents)
        

        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        composeTextField.leftViewMode = .always
        composeTextField.leftView = spacerView


        composeBar.backgroundColor = .black
        composeBar.addSubview(addPhotoButton)
        composeBar.addSubview(composeTextField)
        composeBar.addSubview(sendButton)
        view.addSubview(composeBar)
    }
    
    func initTableview() {
        chatView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: composeBar.frame.minY))
        chatView.backgroundColor = .black
        chatView.separatorStyle = .none
        chatView.keyboardDismissMode = .interactive
        chatView.register(ChatCell.self, forCellReuseIdentifier: "chatCell")
        chatView.dataSource = self
        chatView.delegate = self
        chatView.indicatorStyle = .white
        
        chatView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        view.addSubview(chatView)
        view.sendSubviewToBack(chatView)
    }
    

    func keyboardRehandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        
    }
    
}
