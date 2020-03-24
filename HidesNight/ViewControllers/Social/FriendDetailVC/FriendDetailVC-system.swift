
//
//  FriendDetailVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/25/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite
import JGProgressHUD

extension FriendDetailVC {
    func setupManagers() {
		alerts = AlertManager(vc: self, defaultHandler: {
            self.hud?.indicatorView = JGProgressHUDSuccessIndicatorView(contentView: self.view)
            self.hud?.detailTextLabel.text = ""
            self.hud?.dismiss(afterDelay: 0.5, animated: true)
            Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false, block: { (t) in
                self.dismiss(animated: true, completion: nil)
            })
        })
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidAppear(_ animated: Bool) {

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
