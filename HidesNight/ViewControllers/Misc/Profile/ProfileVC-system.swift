//
//  ProfileVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/23/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension ProfileVC {
    func setupManagers() {
		alerts = AlertManager(vc: self, defaultHandler: {

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
    @objc func toInstructions() {
        guard let parentVC = storyboard?.instantiateViewController(withIdentifier: "InstructionsParent") else {return}
        self.present(parentVC, animated: true, completion: nil)
    }

}
