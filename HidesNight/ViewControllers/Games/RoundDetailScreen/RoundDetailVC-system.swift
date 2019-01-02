//
//  RoundDetailVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/29/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import UIKit
import MapKit
import CoreLocation
import iosManagers
import JGProgressHUD


extension RoundDetailVC {
    func setupManagers() {
        alerts = AlertManager(view: self, stateRestoration: {
            self.hud?.indicatorView = JGProgressHUDSuccessIndicatorView(contentView: self.view)
            self.hud?.textLabel.text = "Done!"
            self.hud?.detailTextLabel.text = ""
            self.hud?.dismiss(afterDelay: 1.25, animated: true)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (t) in
                self.navigationController?.popViewController(animated: true)
            })
            self.view.isUserInteractionEnabled = true
        })
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidAppear(_ animated: Bool) {

    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TeamSelectorVC {
            vc.game = self.game
            vc.callback = { (team) in
                self.round.seeker = team
                self.setTeamVisible(true)
                return
            }
        }
    }

    // Segue Out Helpers
    @objc func toTeamSelect() {
        performSegue(withIdentifier: "round2teamPick", sender: self)
    }
    
    // UI FUnctions
    @objc func dismissKeyboard() {
        roundName.resignFirstResponder()
        
    }
    @objc func changeTitle() {
        self.title = roundName.text
        
        if roundName.text == "" {
            roundName.errorMessage = "Round Name can't be Blank"
        } else {
            roundName.errorMessage = ""
        }
        
    }
    
    func setBarButton(valid: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = valid
    }

}
