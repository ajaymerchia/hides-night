//
//  CreateGameVC-system.swift
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
    func setupManagers() {
        alerts = AlertManager(view: self, stateRestoration: {

        })
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidAppear(_ animated: Bool) {
        if firstLoad {
            firstLoad = false
            UIMenuController.shared.setMenuVisible(false, animated: false)
            gameNameField.selectAll(self)
            
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    // Segue Out Functions
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }

}
