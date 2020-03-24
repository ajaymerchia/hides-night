//
//  Slide.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import ARMDevSuite

class Slide: UIView {
    
    var size: CGSize!
    
    var imageView: UIImageView!
    var labelTitle: UITextView!
    var labelDesc: UITextView!
    
    init(size: CGSize, data: SlideData) {
        super.init(frame: CGRect(origin: .zero, size: size))
        self.size = size
        
        createUIElementsFrom(data)
    }
    
    func shiftFrameTo(position: Int) {
        self.frame = CGRect(origin: CGPoint(x: self.size.width * CGFloat(position), y: 0), size: size)
    }
    
    func createUIElementsFrom(_ data: SlideData) {
        
        let safeWidth = self.frame.width * 0.75
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: safeWidth, height: safeWidth))
        imageView.center = CGPoint(x: self.size.width/2, y: .PADDING*3 + safeWidth/2)
        imageView.contentMode = .scaleAspectFit
        imageView.image = data.image
        self.addSubview(imageView)
        
        labelTitle = UITextView(frame: LayoutManager.belowCentered(elementAbove: imageView, padding: .PADDING, width: safeWidth, height: 40))
        labelTitle.font = .SUBTITLE_FONT
        labelTitle.textColor = .ACCENT_BLUE
        labelTitle.backgroundColor = .clear
        labelTitle.text = data.header
        labelTitle.textAlignment = .center
        labelTitle.isScrollEnabled = false
        labelTitle.isUserInteractionEnabled = false
        self.addSubview(labelTitle)
        
        labelDesc = UITextView(frame: LayoutManager.belowCentered(elementAbove: labelTitle, padding: .PADDING, width: safeWidth, height: self.size.height - (labelTitle.frame.maxY + .PADDING)))
        labelDesc.font = .TEXT_FONT
        labelDesc.textColor = .white
        labelDesc.backgroundColor = .clear
        labelDesc.text = data.detail
        labelDesc.textContainer.lineBreakMode = .byWordWrapping
        labelDesc.textAlignment = .center
        labelDesc.isScrollEnabled = false
        labelDesc.isUserInteractionEnabled = false
        self.addSubview(labelDesc)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
