//
//  TeamSelectorVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit

class TeamSelectorVC: UIViewController {

    var game: Game!
    var explictTeamList: [Team]?
    
    var tableview: UITableView!
    var callback: ((Team) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
