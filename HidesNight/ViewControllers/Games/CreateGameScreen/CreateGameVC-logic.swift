//
//  CreateGameVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension CreateGameVC {
    func getData() {
        self.admin = (self.navigationController as! DataNavVC).user
    }


}
