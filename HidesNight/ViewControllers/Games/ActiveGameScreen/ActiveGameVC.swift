//
//  ActiveGameVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/7/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ARMDevSuite

class ActiveGameVC: UIViewController {

    var user: User!
    var game: Game!
    var round: Round {
        return self.game.currentRound
    }
    var userIsAdmin: Bool {
        return user == game.admin
    }
    var userIsSeeker: Bool {
        return round.seeker?.memberIDs.keys.contains(self.user.uid) ?? false
    }
    
    
    var teamToShow: Team!
    
    
    // UI Elements
    var gameTitle: UILabel!
    var gameStatus: UILabel!
        var gameStatusSwitcher: Timer?
        var gameStatusIndex: Int = 0
    
    var roundMap: MKMapView!
    
    var sideControlWidth: CGFloat!
    var sideControls: UIView!
        var openChatButton: UIButton!
        var startGameButton: UIButton!
        var nextGameButton: UIButton!
        var checkInButton: UIButton!
        var caughtButton: UIButton!
        var timerButton: UIButton!
    
    var segSwitchButtons = [UIButton]()
    var currentSegSelected = 0
    var segTitles = ["Time Left", "Teams"]
    var indicatorView: UIView!
    var leftSwipe: UISwipeGestureRecognizer!
    var rightSwipe: UISwipeGestureRecognizer!
    
    var tableView: UITableView!
    var countdownCells = [CountDownCell]()
    
    
    // Map Round Control
    let borderColor = rgba(0, 88, 230, 0.7)
    var locationManager: CLLocationManager!
    var tapTracker: UITapGestureRecognizer!
    var boundaries = [MKPointAnnotation]()
    var borderDrawing: MKPolyline!
    
    // Map Team Control
    var showLocation: Bool {
        return round.roundStatus == RoundStatus.seekWithGPS
        
    }
    var teamLocationAnnotations = [MKAnnotation]()
    var teamLocationAccuracyCircle: MKCircle?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.sideControlWidth = self.view.frame.width/5
        setupManagers()
        self.initUI()
        self.updateUIComponents()
        self.recenter()
        self.setUpChangeListener()
        
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
