//
//  ProfileVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/23/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension ProfileVC {
    @objc func pickProfilePhoto() {
        let actionSheet = UIAlertController(title: "Select Photo From", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (action) -> Void in
            self.createImagePicker(preferredType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
    @objc func performLogout() {
        FirebaseAPIClient.logout(user: self.user)
        self.dismiss(animated: true, completion: {})
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: {})
        
        
        
    }


}
