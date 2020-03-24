//
//  ProfileVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/22/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import ARMDevSuite

class ProfileVC: UIViewController {

    var alerts: AlertManager!
    var user: User!
    
    var profileImg: UIButton!
    var name: UILabel!
    
    var helpButton: UIButton!
    var helpText: UILabel!
    var logoutButton: UIButton!
    var logoutText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
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
