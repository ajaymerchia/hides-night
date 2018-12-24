//
//  InstructionsVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/23/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import FSPagerView

class InstructionsVC: UIViewController {
    var navbar: UINavigationBar!
    var slideData: [SlideData]!
    var slides: [Slide]!
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createSlides()
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
