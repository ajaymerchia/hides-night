//
//  GamesVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/22/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit

class GamesVC: UIViewController {

    // Models
    var user: User!
    
    // Navbar
    var profilePictureButton: UIButton!
    var navbar: UINavigationBar!
    
    
    // Game Creation
    var newGameButton: UIButton!
    
    // Upcoming/Previous Games
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getUserFromParent()
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
