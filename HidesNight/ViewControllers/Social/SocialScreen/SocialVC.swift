//
//  SocialVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import iosManagers
import JGProgressHUD

class SocialVC: UIViewController {
    // Models
    var user: User!
    var friendSelected: User!
    var selectedIsRequest: Bool!
    
    static let headerNames = ["Game Invites", "Friend Requests", "Friends"]
    var tableData: [[Any]] = [[],[],[]]
    var sectionsToDisplay: [String] = []
    
    var alerts: AlertManager!
    var hud: JGProgressHUD?
    
    // Navbar
    var profilePictureButton: UIButton!
    var navbar: UINavigationBar!
    
    // Controls
    var friendsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupManagers()
        getUserFromParent()
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
