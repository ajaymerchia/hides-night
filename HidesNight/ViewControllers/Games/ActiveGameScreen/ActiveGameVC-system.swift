//
//  ActiveGameVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/7/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension ActiveGameVC {
    func setupManagers() {
//        alerts = AlertManager(view: self, stateRestoration: {
//
//        })
    }

    override func viewWillAppear(_ animated: Bool) {
        guard var vcs = self.navigationController?.viewControllers else { return }
        if vcs[vcs.count - 2] is GameDetailVC {
            self.navigationController?.viewControllers.remove(at: vcs.count-2)
        }
        
        FirebaseAPIClient.updateGame(self.game) {
            self.updateUIComponents()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? GameDetailVC {
            detail.game = self.game
            detail.user = self.user
        } else if let detail = segue.destination as? TeamReadOnlyVC {
            detail.team = teamToShow
        }
    }
    
    func getTabBarProxy() -> UIView {
        let tabFrame = (tabBarController?.tabBar.frame)!
        let navBarHeight = navigationController!.navigationBar.frame.height
        
        let originPoint = CGPoint(x: 0, y: view.frame.height - (navBarHeight * 1.5 + tabFrame.height))
        
        let actualTabFrame = CGRect(origin: originPoint, size: CGSize(width: tabFrame.width, height: tabFrame.height))
        
        let newView = UIView(frame: actualTabFrame)
        return newView
    }
    
    // Segue Out Functions
    @objc func goToDetails() {
        self.performSegue(withIdentifier: "active2detail", sender: self)
        
    }

}
