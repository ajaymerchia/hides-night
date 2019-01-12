//
//  TabBarVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/22/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import SideMenu

class TabBarVC: UITabBarController {

    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "SideMenuNav") as! UISideMenuNavigationController
//        let menuRightNavigationController = UISideMenuNavigationController(rootViewController: self)
//        
//        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
//        SideMenuManager.default.menuRightNavigationController = menuRightNavigationController
//        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
//        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        for viewController in self.viewControllers ?? [] {
            if let navigationVC = viewController as? UINavigationController, let rootVC = navigationVC.viewControllers.first {
                let _ = rootVC.view
            } else {
                let _ = viewController.view
            }
        }
        
        
//        if let deviceToken = (UIApplication.shared.delegate as? AppDelegate)?.fcmToken {
//            FirebaseAPIClient.setDeviceToken(to: deviceToken, forUser: self.user, completion: {})
//        }
        
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
