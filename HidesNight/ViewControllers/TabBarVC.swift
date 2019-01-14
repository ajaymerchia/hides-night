//
//  TabBarVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/22/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import SideMenu
import NotificationCenter

class TabBarVC: UITabBarController {

    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        for viewController in self.viewControllers ?? [] {
            if let navigationVC = viewController as? UINavigationController, let rootVC = navigationVC.viewControllers.first {
                let _ = rootVC.view
            } else {
                let _ = viewController.view
            }
        }
        
        
        if let deviceToken = (UIApplication.shared.delegate as? AppDelegate)?.fcmToken {
            FirebaseAPIClient.setDeviceToken(to: deviceToken, forUser: self.user, completion: {})
        }
        
        
    }
    
    func resetVCs() {
        guard let navVCs = self.viewControllers as? [UINavigationController] else {
            return
        }
        for vc in navVCs {
            vc.presentedViewController?.dismiss(animated: false, completion: nil)
            vc.popToRootViewController(animated: false)
            vc.navigationBar.isHidden = false
        }
        self.tabBar.isHidden = false
    }
    
    @objc func loadGames() {
        resetVCs()
        self.selectedIndex = 0
    }
    
    @objc func loadSocial() {
        resetVCs()
        self.selectedIndex = 1
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
