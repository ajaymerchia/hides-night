//
//  AddFriendVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import ARMDevSuite
import JGProgressHUD
import HGPlaceholders

class AddFriendVC: UIViewController {
	
	static var user: User?

    var user: User!
    var allUsers: [User] = []
    
    var requestsToSend: [User] = []
    
    var sectionsToDisplay: [String] = []
    
    var searchResults: [User] = []
    var requestsToDisplay: [User] = []
    var existingContacts: [User] = []
    var compiledResults: [[User]] = []

    
    var alerts: AlertManager!
    var hud: JGProgressHUD?
    
    var navbar: UINavigationBar!
    var tableview: UITableView!
    var searchBox: UITextField!
    var sendRequests: UIButton!
    
    var noResultsIndicator: UIView!
    
    var originalContentPosition: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupManagers()
        initUI()
        getData()
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
