//
//  ChatVC-logic.swift
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
    @objc func sendTextMessage() {
        guard let msg = composeTextField.text else { return }
        addPhotoButton.isUserInteractionEnabled = false
        
        self.composeTextField.text = ""
        
        if msg == "" {
            if let imgToSend = photoSelected() {
                sendImageMessage(img: imgToSend)
            }
            return
        }
        

        
        let textMessage = Message(msg: msg, sender: self.user)
        
        
        FirebaseAPIClient.send(message: textMessage, to: self.chat) {
            debugPrint("message sent!")
            if let imgToSend = self.photoSelected() {
                self.sendImageMessage(img: imgToSend)
            }
        }
        
        addMessage(msg: textMessage)
        
        
        
    }
    
    func sendImageMessage(img: UIImage) {
        let imageMessage = Message(img: img, sender: self.user)
        
        
        FirebaseAPIClient.send(message: imageMessage, to: self.chat) {
            self.resetPhotoPicker()
            
        }
        addMessage(msg: imageMessage)
    }
    
    func loadChats() {
        
        pureMessages = []
        for (_, messages) in self.chat.messages {
            pureMessages.append(contentsOf: messages)
        }
        pureMessages.sort()
    }
    
    func setUpNewMessageListener() {
        FirebaseAPIClient.setUpNewMessageListenerFor(chat: self.chat) { (msg) in
            
            if self.pureMessages.contains(msg) { return }

            if msg.imgPending {
                
                msg.imageLoaded = {
                    if msg.img != nil {
                        self.addMessage(msg: msg)
                    }
                }
                
                
            } else {
                self.addMessage(msg: msg)
            }
            
           
            
        }
    }
    
    func addMessage(msg: Message) {
        
        if pureMessages.contains(msg) { return }
        
        self.loadChats()
        self.chatView.beginUpdates()
        self.pureMessages.append(msg)
        self.pureMessages.sort()
        self.chatView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        self.chatView.endUpdates()
    }
    
    @objc func requestImageMessage() {
        let actionSheet = UIAlertController(title: "Send Photo From", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .photoLibrary)
        }))
        if photoSelected() != nil {
            actionSheet.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler: { (action) -> Void in
                // Animate the Top UIView away
                self.resetPhotoPicker()
                
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = addPhotoButton
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.present(actionSheet, animated: true)
    }
    
    func resetPhotoPicker() {
        addPhotoButton.setImage(UIImage.nav_add_image.withRenderingMode(.alwaysTemplate), for: .normal)
        addPhotoButton.imageView?.contentMode = .scaleAspectFit
        sendButton.isEnabled = false
        addPhotoButton.isUserInteractionEnabled = true
        
    }
    
    func photoSelected() -> UIImage? {
        let returnable = self.addPhotoButton.image(for: .normal)
        if returnable != UIImage.nav_add_image.withRenderingMode(.alwaysTemplate) {
            return returnable
        } else {
            return nil
        }
    }
    
    
    @objc func imageTapped(img: UIImage) {
        
        debugPrint(img.size)
        
        overlayImageView = UIImageView(frame: UIScreen.main.bounds)
        overlayImageView.backgroundColor = .black
        overlayImageView.contentMode = .scaleAspectFit
        overlayImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        overlayImageView.addGestureRecognizer(tap)
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(sharePhoto))
        overlayImageView.addGestureRecognizer(longTap)
        
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: overlayImageView.frame.height - 50, width: overlayImageView.frame.width, height: 50))
        navbar.isTranslucent = true
        navbar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navbar.shadowImage = UIImage()
        
        let item = UINavigationItem(title: "")
        item.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePhoto))
        item.leftBarButtonItem?.tintColor = .white
        navbar.items = [item]
        overlayImageView.addSubview(navbar)
        
        
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        swipe.direction = .down
        overlayImageView.addGestureRecognizer(swipe)
        
        overlayImageView.alpha = 0
        overlayImageView.image = img
        self.view.addSubview(overlayImageView)
        
        UIView.animate(withDuration: 0.25) {
            self.overlayImageView.alpha = 1
            self.navigationController?.isNavigationBarHidden = true
        }
        
        
        
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.25, animations: {
            sender.view?.alpha = 0
            self.navigationController?.isNavigationBarHidden = false
            
        }) { (b) in
            sender.view?.removeFromSuperview()
        }
        
    }
    
    @objc func sharePhoto() {
        let items: [Any] = [overlayImageView.image!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }


}
