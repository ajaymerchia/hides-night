//
//  ChatVC-photopicker.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/7/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import ARMDevSuite
import UIKit

extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func createImagePicker(preferredType: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker.sourceType = preferredType
            picker.allowsEditing = false
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(picker, animated: true, completion: nil)
        }
        else {
            picker.sourceType = .photoLibrary
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        addPhotoButton.setImage(chosenImage, for: .normal)
        addPhotoButton.imageView?.contentMode = .scaleAspectFill
        sendButton.isEnabled = true
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
