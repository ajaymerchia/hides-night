//
//  DecisionPickerVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/27/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension DecisionPickerVC {
    func initUI() {
        initNav()
        initScrollView()
        self.slides = createSlidesFrom(data: slideData)
        self.view.backgroundColor = .black
        addSlidesToScrollView()
        addButton()
        addPageControl()
    }
    
    // UI Initialization Helpers
    func initNav() {
        if isTeamSlides {
            self.title = "Team Selection"
        } else {
            self.title = "Seeker Selection"
        }
    }
    
    func initScrollView() {
        scrollView = UIScrollView(frame: LayoutManager.belowCentered(elementAbove: (self.navigationController?.navigationBar)!, padding: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slideData.count), height: 0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        view.addSubview(scrollView)
    }
    
    func addSlidesToScrollView() {
        for i in 0 ..< slides.count {
            slides[i].shiftFrameTo(position: i)
            scrollView.addSubview(slides[i])
        }
    }
    
    func createSlidesFrom(data: [SlideData]) -> [Slide]{
        var producedSlides:[Slide] = []
        
        for datum in data {
            producedSlides.append(Slide(size: CGSize(width: view.frame.width, height: scrollView.frame.height), data: datum))
        }
        return producedSlides
    }
    
    func addPageControl() {
        pageControl = UIPageControl(frame: LayoutManager.aboveCentered(elementBelow: selectCurrentMode, padding: .PADDING, width: view.frame.width, height: 40))
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ACCENT_BLUE
        pageControl.pageIndicatorTintColor = .white
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
    }
    
    func addButton() {
        selectCurrentMode = UIButton(frame: CGRect(x: 0, y: view.frame.height - (80), width: view.frame.width, height: 80))
        selectCurrentMode.setBackgroundColor(color: .ACCENT_BLUE, forState: .normal)
        selectCurrentMode.setTitle("Save Mode", for: .normal)
        selectCurrentMode.titleLabel?.font = .SUBTITLE_FONT
        selectCurrentMode.addTarget(self, action: #selector(returnDataToParent), for: .touchUpInside)
        view.addSubview(selectCurrentMode)
        
    }
    
    

}
