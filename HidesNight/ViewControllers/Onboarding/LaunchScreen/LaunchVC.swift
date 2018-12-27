//
//  LaunchVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/19/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import iosManagers
import JGProgressHUD


class LaunchVC: UIViewController {

    var logo: UIImageView!
    var gameTitle: UILabel!
    
    var pendingUser: User!
    var hud: JGProgressHUD?
    
    var hasLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
                
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !hasLoaded {
            UIView.animate(withDuration: 1, delay: 0.25, options: .curveEaseInOut, animations: {
                self.logo.frame = LayoutManager.aboveCentered(elementBelow: self.gameTitle, padding: .PADDING*10, width: self.logo.frame.width, height: self.logo.frame.height)
                self.gameTitle.frame =  LayoutManager.belowCentered(elementAbove: self.logo, padding: .PADDING, width: self.view.frame.width, height: 60)
                self.gameTitle.alpha = 1
            }) { (bool) in
                self.checkForAutoLogin()
                self.hasLoaded = true
            }
        } else {
            self.checkForAutoLogin()
        }
    }
    
    func initUI() {
        view.backgroundColor = .DARK_BLUE
        
        logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        logo.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        logo.image = .logo_dark
        
        view.addSubview(logo)
        
        
        gameTitle = UILabel(frame: LayoutManager.belowCentered(elementAbove: logo, padding: .PADDING, width: view.frame.width, height: 60))
        gameTitle.textAlignment = .center
        gameTitle.text = "Hides Night"
        gameTitle.font = .TITLE_FONT
        gameTitle.textColor = .white
        gameTitle.alpha = 0
        view.addSubview(gameTitle)
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
