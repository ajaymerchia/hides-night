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
        let navVC = self.navigationController as! DataNavVC
        
        if let newDate = navVC.date {
            self.date = newDate
            navVC.date = nil
            dateTimeCell.detailTextLabel?.text = myUtils.getFormattedDateAndTime(date: self.date)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        debugPrint(roundDurationCell.textLabel?.frame)
    }

    override func viewWillDisappear(_ animated: Bool) {
        eventNameField.resignFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dtVC = segue.destination as? DateTimeVC {
            dtVC.currentDate = self.date
        }
    }

    // Segue Out Functions
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }

}
