//
//  DecisionPickerVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/26/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit

class DecisionPickerVC: UIViewController {
    var navbar: UINavigationBar!
    var slideData: [SlideData]!
    var slides: [Slide]!
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    var selectCurrentMode: UIButton!
    
    var selectedDecisionStyle: GameSelectionType!
    var isTeamSlides: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isTeamSlides {
            createTeamSlides()
        } else {
            createSeekerSlides()
        }
        initUI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
