//
//  InviteFriendVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/28/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import ARMDevSuite
import JGProgressHUD

class InviteFriendVC: UIViewController {

    var user: User!
    var game: Game!
    
    var alerts: AlertManager!
    var hud: JGProgressHUD?
    var succesfulSend = false
    
    var navbar: UINavigationBar!
    var tableview: UITableView!
    var searchBox: UITextField!
    var sendInvites: UIButton!
    
    var searchResults: [User] = []
    var friendsToShow: [User] = []
    var invitesToSend: [User] = []
    
    var friendsTable: UITableView!
    var originalContentPosition: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getDataFromParent()
        
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
