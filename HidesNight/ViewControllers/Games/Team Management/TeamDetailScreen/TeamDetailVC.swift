//
//  TeamDetailVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/28/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import ARMDevSuite
import JGProgressHUD

class TeamDetailVC: UIViewController {

    var game: Game!
    var user: User!
    var team: Team!
    
    var alerts: AlertManager!
    var hud: JGProgressHUD?
    
    // Team Attributes
    var teamPhoto: UIButton!
    var teamName: LabeledTextField!
    
    // User Selector
    var slots = [UIButton]()
    var slotsFilled = [UIView]()
    var slotData: [User?] = [nil, nil, nil]
    var indexSelected: Int!
    var selectionVC: TeamMemberSelectVC!
    
    var firstLoad = true
    var photoChanged = false
    
    var isTeamDictator: Bool {
        return self.user == game.admin
    }
    
    var isTeamManager: Bool {
        return self.user == game.admin || self.game.teamSelection == .Chosen
    } // These users can manage their **own** membership
    
    var isTeamContributor: Bool {
        if self.user == game.admin {
            return true
        } else if slotData.contains(self.user) {
            return true
        } else {
            return false
        }
    } // These users can change the team name, change the photo, etc.
    
    var hasPermissions: Bool {
        return isTeamDictator || isTeamManager || isTeamContributor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupManagers()
        loadData()
        initUI()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
