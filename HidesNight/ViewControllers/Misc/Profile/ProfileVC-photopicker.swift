//
//  ProfileVC-photopicker.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/23/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import ARMDevSuite

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func createImagePicker(preferredType: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker.sourceType = preferredType
            picker.allowsEditing = true
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(picker, animated: true, completion: nil)
        }
        else {
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImg.setImage(chosenImage, for: .normal)
        user.profilePic = chosenImage
        FirebaseAPIClient.uploadProfileImage(forUsername: user.username, withImage: chosenImage, success: {}, fail: {})
        
        let dataToPost = ["img": chosenImage]
        NotificationCenter.default.post(name: .newImage, object: nil, userInfo: dataToPost as [AnyHashable : Any])
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

