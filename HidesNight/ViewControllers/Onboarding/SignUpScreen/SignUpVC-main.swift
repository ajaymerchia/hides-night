//
//  SignUpVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import JGProgressHUD
import ARMDevSuite
import SkyFloatingLabelTextField


class SignUpVC: UIViewController {

    var alerts: AlertManager!
    var hud: JGProgressHUD?
    var restrictedUsernames: [String]!
    var restrictedEmails: [String]!
    
    var navbar: UINavigationBar!
    
    var signUpPrompt: UILabel!
    
    var profileSelectButton: UIButton!
    
    var firstNameTextfield: LabeledTextField!
    var lastNameTextfield: LabeledTextField!
    var emailTextfield: LabeledTextField!
    var userNameTextfield: LabeledTextField!
    var pw1Textfield: LabeledTextField!
    var pw2Textfield: LabeledTextField!
    
    var textFieldTag = 0
    
    var signUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadRestrictedAccounts()
        initUI()
        addValidators()
        setupManagers()
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
