//
//  GameDetailVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/27/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import iosManagers
import BetterSegmentedControl

class GameDetailVC: UIViewController {
    
    var game: Game!
    var user: User!
    var userIsAdmin: Bool {
        return user == game.admin
    }
    var isGameInvite: Bool {
        return (self.game.getPlayerStatus(forUser: self.user) == .invited)
    }
    var firstLoad = true
    
    var teamToShow: Team!
    var roundToShow: Round!
    
    
    
    // UI!
    var navbar: UINavigationBar!
    
    // Information
    var gamePhoto: UIImageView!
    var gameParamsHidden = false
    var gameParamToggler: UITapGestureRecognizer!
    var gameParams: UIView!
        // Durations & Selection Styles, done as "windows"
    
    var gameTitle: UILabel!
    var gameTime: UILabel!
    
    // Overall Control
    var overallButtonHolder: UIView!
    var rightActionButton: UIButton! 
    var leftActionButton: UIButton!
    
    // TableControls
    var segSwitch: BetterSegmentedControl!
    var tableViewTitles = ["Players", "Teams", "Rounds"]
    var createTitles = ["Invite Players", "Create a Team", "Add a Round"]
    var segSwitchButtons =  [UIButton]()
    var indicatorView: UIView!
    var currentSegSelected = 0
    var leftSwipe: UISwipeGestureRecognizer!
    var rightSwipe: UISwipeGestureRecognizer!
    
    // Table
    var tableView: UITableView!
    var createCellButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupManagers()
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
