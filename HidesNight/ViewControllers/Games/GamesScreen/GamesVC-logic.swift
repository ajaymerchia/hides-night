//
//  GamesVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/22/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers

extension GamesVC {
    func getUserFromParent() {
        let parentTab = (self.tabBarController as! TabBarVC)
        self.user = parentTab.user
    }


}
