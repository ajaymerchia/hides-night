//
//  AddFriendVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension AddFriendVC {
    func setupManagers() {
        alerts = AlertManager(view: self, stateRestoration: {
            self.hud?.dismiss()
            self.view.isUserInteractionEnabled = true
        })
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidAppear(_ animated: Bool) {
        searchBox.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    // Segue Out Functions
    @objc func goBack() {
        searchBox.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }

}
