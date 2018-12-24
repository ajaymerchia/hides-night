//
//  SlideData.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit

struct SlideData {
    var header: String
    var detail: String
    var image: UIImage
    
    init(header: String, detail: String, image: UIImage) {
        self.header = header
        self.detail = detail
        self.image = image
    }
}
