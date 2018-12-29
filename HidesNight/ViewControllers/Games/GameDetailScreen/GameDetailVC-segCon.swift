//
//  GameDetailVC-segCon.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/28/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers
extension GameDetailVC {
    func initSegControl() {
        for i in 0..<3 {
            let width:CGFloat = (view.frame.width - 2 * .PADDING)/3
            let button = UIButton(frame: CGRect(x: .PADDING + width * CGFloat(i), y: overallButtonHolder.frame.maxY + .PADDING, width: width, height: 30))
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.white, for: .highlighted)
            button.addTarget(self, action: #selector(segControlWasTapped(_:)), for: .touchUpInside)
            button.setTitle(tableViewTitles[i], for: .normal)
            button.titleLabel?.font = .HEADER_FONT
            
            button.tag = i
            segSwitchButtons.append(button)
            view.addSubview(button)
            
        }
        
        segSwitchButtons[currentSegSelected].isSelected = true
        segSwitchButtons[currentSegSelected].setTitleColor(.ACCENT_BLUE, for: .highlighted)
        segSwitchButtons[currentSegSelected].setTitleColor(.ACCENT_BLUE, for: .normal)
        
        indicatorView = UIView(frame: LayoutManager.belowCentered(elementAbove: segSwitchButtons[currentSegSelected], padding: 0, width: segSwitchButtons[currentSegSelected].frame.width, height: 5))
        indicatorView.backgroundColor = .ACCENT_BLUE
        view.addSubview(indicatorView)
        
        
        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        leftSwipe.direction = .left
        
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        
        
    }
    
    @objc func segControlWasTapped(_ sender: UIButton) {
        
        if sender.tag == currentSegSelected {
            return
        }
        
        for button in segSwitchButtons {
            button.isSelected = false
            button.setTitleColor(.white, for: .highlighted)
            button.setTitleColor(.white, for: .normal)
        }
        
        sender.setTitleColor(.ACCENT_BLUE, for: .highlighted)
        sender.setTitleColor(.ACCENT_BLUE, for: .normal)
        self.currentSegSelected = sender.tag
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.indicatorView.frame = LayoutManager.belowCentered(elementAbove: self.segSwitchButtons[sender.tag], padding: 0, width: self.segSwitchButtons[sender.tag].frame.width, height: 5)
        })
        
        tabChanged(index: sender.tag)
        
        
    }
    
    @objc func didSwipeLeft() {
        view.isUserInteractionEnabled = false
        let nextButton = segSwitchButtons[min(segSwitchButtons.count-1, currentSegSelected + 1)]
        if leftSwipe.location(in: self.view).y > nextButton.frame.minY {
            segControlWasTapped(nextButton)
        }
        view.isUserInteractionEnabled = true
        
    }
    
    @objc func didSwipeRight() {
        view.isUserInteractionEnabled = false
        let prevButton = segSwitchButtons[max(0, currentSegSelected - 1)]
        if rightSwipe.location(in: self.view).y > prevButton.frame.minY {
            segControlWasTapped(prevButton)
        }
        view.isUserInteractionEnabled = true
    }
}
