//
//  CreateGameVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import iosManagers
import JGProgressHUD

class CreateGameVC: UIViewController {

    var admin: User!
    
    var alerts: AlertManager!
    var hud: JGProgressHUD!
    var firstLoad = true

    var navbar: UINavigationBar!
    var scrollView: UIScrollView!
    
    // Game Metadata
    var gameNameField: LabeledTextField!
    var gameTimeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
