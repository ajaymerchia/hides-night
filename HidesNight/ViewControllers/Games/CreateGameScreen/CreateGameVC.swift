//
//  CreateGameVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import ARMDevSuite
import JGProgressHUD

class CreateGameVC: UIViewController {

    var admin: User!
    var game: Game?
        var editMode = false
        var photoChanged = false
    
    var alerts: AlertManager!
    var hud: JGProgressHUD!
    var successCreation = false
    var internalError = false
    
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
        var roundDuration = TimeInterval.defaultRound
    var checkInDurationCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "durationPicker")
        var checkInDurationLabel: UILabel!
        var checkInDuration = TimeInterval.defaultCheckin
    var gpsActivationCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "durationPicker")
        var gpsActivationLabel: UILabel!
        var gpsActivation = TimeInterval.defaultGPS
    
    var durationPickers = [UIDatePicker]()
    var labels = [UILabel]()
    
    // Team Parameters
    var teamDecisionCell = UITableViewCell(style: .value1, reuseIdentifier: "decisionType")
        var teamDecisionType = GameSelectionType.Assigned
    var seekDecisionCell = UITableViewCell(style: .value1, reuseIdentifier: "decisionType")
        var seekDecisionType = GameSelectionType.Assigned
    
    var awaitingTeam = false
    var awaitingSeek = false
    
    var createButton: UIButton!
    
    var allCells: [[UITableViewCell]] {
        return [
            [eventNameCell, dateTimeCell],
            [roundDurationCell, checkInDurationCell, gpsActivationCell],
            [teamDecisionCell, seekDecisionCell]
        ]
    }
    
    var allBorders = [[UIView]]()
    
	let cellColor: UIColor = .flatBlack()
    let separatorColor: UIColor = .black
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupManagers()
        getData()
        initUI()
        
        if editMode {
            alterForEditMode()
        }
    }
    
    func alterForEditMode() {
        guard let g = self.game else {
            alerts.triggerCallback()
            return
        }
        self.navigationItem.rightBarButtonItem?.title = "Done"
        
        eventNameField.text = g.title
        date = g.datetime
        dateTimeCell.detailTextLabel?.text = myUtils.getFormattedDateAndTime(date: self.date)
        
        roundDuration = g.roundDuration
        checkInDuration = g.checkInDuration
        gpsActivation = g.gpsActivation
        
        update(label: roundDurationLabel, withInterval: roundDuration)
        update(label: checkInDurationLabel, withInterval: checkInDuration)
        update(label: gpsActivationLabel, withInterval: gpsActivation)
        
        durationPickers[0].countDownDuration = self.roundDuration
        durationPickers[1].countDownDuration = self.checkInDuration
        durationPickers[2].countDownDuration = self.gpsActivation
        

        teamDecisionType = g.teamSelection
        seekDecisionType = g.seekSelection
        
        teamDecisionCell.detailTextLabel?.text = teamDecisionType.description
        seekDecisionCell.detailTextLabel?.text = seekDecisionType.description

        
        createButton.setTitle("Update Game", for: .normal)
        
        if let img = g.img {
            animateInHeader(img: img)
        }
        
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
