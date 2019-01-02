//
//  TeamDetailVC-system.swift
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

extension TeamDetailVC {
    func setupManagers() {
        alerts = AlertManager(view: self, stateRestoration: {
            self.hud?.indicatorView = JGProgressHUDSuccessIndicatorView(contentView: self.view)
            self.hud?.textLabel.text = "Done!"
            self.hud?.detailTextLabel.text = ""
            self.hud?.dismiss(afterDelay: 1.25, animated: true)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (t) in
                self.navigationController?.popViewController(animated: true)
            })
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        if !firstLoad {
            grabData()
            addSlots()
            _ = validateTeam()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if firstLoad {
            if team.memberIDs.count == 0 {
                teamName.becomeFirstResponder()
            }
            firstLoad = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        teamName.resignFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let teamMember = segue.destination as? TeamMemberSelectVC {
            teamMember.game = self.game
            teamMember.team = self.team
            teamMember.slots = self.slotData
            teamMember.slotIndex = self.indexSelected
            self.selectionVC = teamMember
        }
    }

    // Segue Out Functions
    @objc func goToMemberSelect(_ sender: UIButton) {
        self.indexSelected = sender.tag
        self.performSegue(withIdentifier: "teamDetail2memberSelect", sender: self)
    }

}
