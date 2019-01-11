//
//  FirebaseAPI-notifications.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/11/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

extension FirebaseAPIClient {
    static func setDeviceToken(to: String, forUser: User, completion: @escaping () -> ()) {
        Database.database().reference().child("deviceTokens").child(forUser.uid).setValue(to) { (err, ref) in
            completion()
        }
    }
    
    
}
