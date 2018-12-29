//
//  GameDetailVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/27/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension GameDetailVC {
    func setupManagers() {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        debugPrint("updating game")
        FirebaseAPIClient.updateGame(self.game, completion: {
            self.tableView.reloadData()
            debugPrint("game updated")
        })
        
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let datavc = segue.destination as? DataNavVC {
            datavc.user = self.user
            datavc.game = self.game
        }
    }

    // Segue Out Functions
    @objc func openCreate() {
        switch self.currentSegSelected {
        case 0:
            self.performSegue(withIdentifier: "detail2invite", sender: self)
        default:
            debugPrint("nada")
        }
    }

}
