//
//  SignUpVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension SignUpVC {
    func setupManagers() {
		alerts = AlertManager(vc: self, defaultHandler: {
            self.alerts.jghud?.dismiss()
            self.view.isUserInteractionEnabled = true
            
            
        })
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidAppear(_ animated: Bool) {

    }

    override func viewWillDisappear(_ animated: Bool) {
        alerts.jghud?.dismiss()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // Segue Out Functions
    @objc func goBack() {
        self.dismiss(animated: true)
    }

}
