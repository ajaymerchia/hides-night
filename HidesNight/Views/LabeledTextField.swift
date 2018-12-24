//
//  LabeledTextField.swift
//  
//
//  Created by Ajay Merchia on 12/20/18.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class LabeledTextField: SkyFloatingLabelTextField {
    
    var additionalDistance: CGFloat = .MARGINAL_PADDING
    
    func setLineDistance(_ distance: CGFloat) {
        additionalDistance = distance
    }
    
    override func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let height = editing ? selectedLineHeight : lineHeight
        return CGRect(x: 0, y: bounds.size.height - height + additionalDistance, width: bounds.size.width, height: height)
    }
    
    func getText() -> String? {
        guard let ret = self.text else {
            return nil
        }
        
        if ret == "" {
            return nil
        } else {
            return ret
        }
        
    }
}
