//
//  LoginVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/19/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import JGProgressHUD
import ARMDevSuite

class LoginVC: UIViewController {
    var logo: UIImageView!
    var gameTitle: UILabel!
    
    var usernameField: LabeledTextField!
    var passwordField: LabeledTextField!
    
    var login: UIButton!
    var signUp: UIButton!
    var howTo: UIButton!
    
    
    var hud: JGProgressHUD!
    
    var alerts: AlertManager!
    var pendingLogin: Bool = false
    var pendingUser: User?
    var firstLoad = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        setupManagers()
        
    }

}
