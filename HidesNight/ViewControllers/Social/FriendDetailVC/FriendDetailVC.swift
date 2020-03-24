//
//  FriendDetailVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/25/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import ARMDevSuite
import JGProgressHUD

class FriendDetailVC: UIViewController {
    // Models
    var user: User!
    var friend: User!
    var pendingRequest: Bool!
    
    var alerts: AlertManager!
    var hud: JGProgressHUD?
    
    // Navbar
    var navbar: UINavigationBar!
    
    // Controls
    var profilePictureButton: UIButton!
    var name: UILabel!
    
    var accept: UIButton!
    var decline: UIButton!
    
    var remove: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupManagers()
        getData()
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
