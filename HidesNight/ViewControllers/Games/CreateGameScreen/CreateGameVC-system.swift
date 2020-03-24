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
import ARMDevSuite
import JGProgressHUD

extension CreateGameVC {
    func setupManagers() {
		alerts = AlertManager(vc: self, defaultHandler: {
            if self.successCreation {
                self.hud?.indicatorView = JGProgressHUDSuccessIndicatorView(contentView: self.view)
                self.hud?.detailTextLabel.text = ""
                self.hud?.dismiss(afterDelay: 0.75, animated: true)
                Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { (t) in
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView(contentView: self.view)
                if self.internalError {
                    self.hud?.detailTextLabel.text = ""
                } else {
                    self.hud.textLabel.text = "Error"
                    self.hud?.detailTextLabel.text = "Game Title Missing"
//                    self.eventNameField.shake()
                    self.eventNameCell.shake()
                }
                self.hud?.dismiss(afterDelay: 1.25, animated: true)
                self.view.isUserInteractionEnabled = true
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        let navVC = self.navigationController as! DataNavVC
        
        if let newDate = navVC.date {
            self.date = newDate
            navVC.date = nil
            dateTimeCell.detailTextLabel?.text = myUtils.getFormattedDateAndTime(date: self.date)
        }
        if let newSelectionStyle = navVC.selectionType {
            navVC.selectionType = nil
            if awaitingTeam {
                awaitingTeam = false
                self.teamDecisionType = newSelectionStyle
                self.teamDecisionCell.detailTextLabel?.text = self.teamDecisionType.description
            } else if awaitingSeek {
                awaitingSeek = false
                self.seekDecisionType = newSelectionStyle
                self.seekDecisionCell.detailTextLabel?.text = self.seekDecisionType.description
            }
        } else {
            awaitingTeam = false
            awaitingSeek = false
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        eventNameField.resignFirstResponder()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dtVC = segue.destination as? DateTimeVC {
            dtVC.currentDate = self.date
        } else if let decisionPicker = segue.destination as? DecisionPickerVC {
            if awaitingTeam {
                decisionPicker.isTeamSlides = true
                decisionPicker.selectedDecisionStyle = teamDecisionType
            } else {
                decisionPicker.isTeamSlides = false
                decisionPicker.selectedDecisionStyle = seekDecisionType
            }
        }
    }

    // Segue Out Functions
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }

}
