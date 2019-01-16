//
//  DecisionPickerVC-data.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/27/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension DecisionPickerVC {
    func createTeamSlides() {
        self.slideData = []
        
        slideData.append(SlideData(header: "Assigned",
                                   detail: "Admin (Game Creator) decides the teams.",
                                   image: .select_assigned))
        slideData.append(SlideData(header: "Chosen",
                                   detail: "Anyone can choose who is on their team!",
                                   image: .select_chosen))
//        slideData.append(SlideData(header: "Random",
//                                   detail: "Let fate decide who your partners will be.",
//                                   image: .logo_dark))
    }
    
    func createSeekerSlides() {
        self.slideData = []
        
        slideData.append(SlideData(header: "Assigned",
                                   detail: "Admin (Game Creator) decides who the seekers are for each round.",
                                   image: .select_assigned))
//        slideData.append(SlideData(header: "Chosen",
//                                   detail: "The group will vote who the seeker is for each round.",
//                                   image: .logo_dark))
        slideData.append(SlideData(header: "Random",
                                   detail: "Let fate decide who the seekers will be.",
                                   image: .select_random))
    }
    
    @objc func returnDataToParent() {
        if self.isTeamSlides {
            (self.navigationController as! DataNavVC).selectionType = [GameSelectionType.Assigned, GameSelectionType.Chosen][pageControl.currentPage]
        } else {
            (self.navigationController as! DataNavVC).selectionType = [GameSelectionType.Assigned, GameSelectionType.Randomized][pageControl.currentPage]
        }
        
        
        
        self.navigationController?.popViewController(animated: true)
    }


}
