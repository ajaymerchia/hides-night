
//
//  InviteFriendVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/28/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers
import JGProgressHUD

extension InviteFriendVC {
    func setupManagers() {
        alerts = AlertManager(view: self, stateRestoration: {
            if self.succesfulSend {
                self.hud?.indicatorView = JGProgressHUDSuccessIndicatorView(contentView: self.view)
                self.hud?.textLabel.text = "Done!"
                self.hud?.detailTextLabel.text = ""
            } else {
                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView(contentView: self.view)
                self.hud?.textLabel.text = "Error"
                self.hud?.detailTextLabel.text = "Could not send all invites."
            }
            self.hud?.dismiss(afterDelay: 1.25, animated: true)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (t) in
                self.dismiss(animated: true, completion: nil)
            })
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
