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
    var tableview: UITableView!
    
    var eventImageHeader: UIImageView!
    
    // Game Metadata
    var eventNameCell = UITableViewCell()
        var eventNameField: UITextField!
        var addImageButton: UIButton!
    var dateTimeCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "dateTime")
        var date: Date = Date.init()
    
    // Game Parameters
    var roundDurationCell = UITableViewCell()
        var roundDurationLabel: UILabel!
        var roundDuration = TimeInterval(myUtils.seconds(hr: 1.5))
    var checkInDurationCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "durationPicker")
        var checkInDurationLabel: UILabel!
        var checkInDuration = TimeInterval(myUtils.seconds(min: 15))
    var gpsActivationCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "durationPicker")
        var gpsActivationLabel: UILabel!
        var gpsActivation = TimeInterval(myUtils.seconds(hr: 1))
    
    var durationPickers = [UIDatePicker]()
    var labels = [UILabel]()
    
    // Team Parameters
    var teamDecisionCell = UITableViewCell(style: .value1, reuseIdentifier: "decisionType")
        var teamDecisionType = GameSelectionType.Assigned
    var seekDecisionCell = UITableViewCell(style: .value1, reuseIdentifier: "decisionType")
        var seekDecisionType = GameSelectionType.Assigned
    
    var allCells: [[UITableViewCell]] {
        return [
            [eventNameCell, dateTimeCell],
            [roundDurationCell, checkInDurationCell, gpsActivationCell],
            [teamDecisionCell, seekDecisionCell]
        ]
    }
    
    var allBorders = [[UIView]]()
    
    let cellColor: UIColor = .flatBlack
    let separatorColor: UIColor = .black
    
    
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
