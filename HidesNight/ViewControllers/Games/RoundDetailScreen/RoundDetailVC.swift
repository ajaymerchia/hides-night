//
//  RoundDetailVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/29/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import iosManagers
import JGProgressHUD

class RoundDetailVC: UIViewController {

    var user: User!
    var game: Game!
    var round: Round!
    
    var alerts: AlertManager!
    var hud: JGProgressHUD?
    
    var roundName: LabeledTextField!
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var tapTracker: UITapGestureRecognizer!
    var boundaries = [MKPointAnnotation]()
    var borderDrawing: MKPolyline!
    
    var instructions: UILabel!
    var selectTeamButton: UIButton!
    var selectedTeam: UIView!
    
    let instructionsList = [
        "Tap the map to add a boundary point.",
        "Tap a pin to remove it.",
        "Drag a pin to alter a boundary point."
    ]
    var instructionsCount = 0
    
    let borderColor = rgba(0, 88, 230, 0.7)
    var hasCalloutSelected = false
    
    var hasPermissions: Bool {
        return self.user == game.admin && self.game.seekSelection != .Randomized
    }
    
    var seekerHeight: CGFloat!
    var seekerFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupManagers()
        initUI()
        recenter()
        
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
