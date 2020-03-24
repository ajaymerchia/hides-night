//
//  InstructionsVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/23/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite


extension InstructionsVC {
    func initUI() {
        initNav()
        initScrollView()
        self.slides = createSlidesFrom(data: slideData)
        addSlidesToScrollView()
        addPageControl()
        addGestureDismissal()
    }

    // UI Initialization Helpers
    func initNav() {
        if let nav = self.navigationController?.navigationBar {
            nav.tintColor = .white
            nav.backgroundColor = .DARK_BLUE
            nav.barTintColor = .DARK_BLUE
            
            nav.titleTextAttributes = [NSAttributedString.Key.font: UIFont.HEADER_FONT!, NSAttributedString.Key.foregroundColor: UIColor.white]
         
            self.navbar = nav
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(goBack))
        
        self.navigationItem.title = "How to Play Hides Night"
        
    }
    
    func initScrollView() {
        scrollView = UIScrollView(frame: LayoutManager.belowCentered(elementAbove: navbar, padding: .PADDING, width: view.frame.width, height: view.frame.height - navbar.frame.maxY))
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slideData.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .DARK_BLUE
        scrollView.delegate = self
        view.addSubview(scrollView)
    }
    
    func addSlidesToScrollView() {
        for i in 0 ..< slides.count {
            slides[i].shiftFrameTo(position: i)
            slides[i].imageView.layer.cornerRadius = slides[i].imageView.frame.width/2
            slides[i].imageView.clipsToBounds = true
            slides[i].imageView.contentMode = .scaleAspectFill
            slides[i].imageView.image = slides[i].imageView.image
            slides[i].imageView.layer.borderColor = UIColor.white.cgColor
            slides[i].imageView.layer.borderWidth = 1.5
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
        pageControl = UIPageControl(frame: CGRect(x: 0, y: view.frame.height - (40 + 2 * .PADDING), width: view.frame.width, height: 40))
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ACCENT_BLUE
        pageControl.pageIndicatorTintColor = .white
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
    }
    
    func addGestureDismissal() {
        let gestureRec = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        gestureRec.direction = .down
        view.addGestureRecognizer(gestureRec)
        
    }
}
