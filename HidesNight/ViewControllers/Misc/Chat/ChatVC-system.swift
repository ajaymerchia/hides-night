//
//  ChatVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/6/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension ChatVC {
    func setupManagers() {
        // force eventual reload
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (t) in
            self.chatView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        composeTextField.text = preloadedText
    }

    override func viewDidAppear(_ animated: Bool) {
        if preloadedText != nil {
            self.sendTextMessage()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
                self.requestImageMessage()
            }
            
            
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    // Segue Out Functions
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }

}
