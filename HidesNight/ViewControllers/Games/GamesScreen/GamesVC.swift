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
    var firstLoad = true
    static let possibleHeaders = ["Active", "Upcoming Games", "Past Games"]
    var tableData: [[Game]] = [[],[],[]]
    var sectionsToDisplay: [String] = []
    var gamesTable: UITableView!
    
    // Prepare for Game Detail
    var gameToDetail: Game!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getUserFromParent()
        setupManagers()
        initUI()
        sortAndDisplayGames()
        
        
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
