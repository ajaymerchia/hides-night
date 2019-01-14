//
//  TeamReadOnlyVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/9/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit

class TeamReadOnlyVC: UIViewController {
    
    var team: Team!
    var game: Game!
    
    var teamPhoto: UIImageView!
    var teamName: UILabel!
    
    var slotsFilled = [UIView]()
    var slotData = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        slotData = team.getMembersOfTeamFrom(game: game)
        
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
