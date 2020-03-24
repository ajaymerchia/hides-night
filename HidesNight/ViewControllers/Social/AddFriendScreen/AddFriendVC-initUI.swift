//
//  AddFriendVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite
import HGPlaceholders

extension AddFriendVC {
    func initUI() {
        self.view.backgroundColor = UIColor.flatBlack()
        initNav()
        initTableView()
        initSendButton()
        prepareNoResults()
    }

    // UI Initialization Helpers
    func initNav() {
        if let nav = self.navigationController?.navigationBar {
            nav.tintColor = .white
            nav.backgroundColor = .black
            nav.barTintColor = .black
            
            nav.titleTextAttributes = [NSAttributedString.Key.font: UIFont.HEADER_FONT!, NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.navbar = nav
        }
        
        searchBox = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        searchBox.textColor = .white
        searchBox.tintColor = .white
        searchBox.font = .TEXT_FONT
        searchBox.attributedPlaceholder = NSAttributedString(string: "Search for Friends...",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.flatWhiteDark()])
        searchBox.returnKeyType = .done
        searchBox.keyboardToolbar.isHidden = true
        searchBox.delegate = self
        searchBox.addTarget(self, action: #selector(runFilter), for: .editingChanged)
        searchBox.addTarget(self, action: #selector(processDoneEditing), for: .editingDidEndOnExit)

        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        self.navigationItem.titleView = searchBox
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(goBack))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.TEXT_FONT!,
                                                                        NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
    func initTableView() {
		tableview = UITableView(frame: .zero); view.addSubview(tableview)
		tableview.translatesAutoresizingMaskIntoConstraints = false
		tableview.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
		tableview.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
		tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
		tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		
        tableview.register(PersonCell.self, forCellReuseIdentifier: "personCell")
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .flatBlack()
        tableview.separatorStyle = .none
        
        tableview.showsVerticalScrollIndicator = false
        
        

        
        
    }
    
    func initSendButton() {
        sendRequests = UIButton(frame: CGRect(x: 0, y: view.frame.height-50, width: view.frame.width, height: 50))
        sendRequests.setTitle("Send Requests", for: .normal)
        sendRequests.setTitleColor(.white, for: .normal)
        sendRequests.titleLabel?.font = .SUBTITLE_FONT
        sendRequests.titleEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        sendRequests.setBackgroundColor(color: UIColor.ACCENT_BLUE.withAlphaComponent(0.90), forState: .normal)
		sendRequests.setBackgroundColor(color: UIColor.ACCENT_BLUE.darken(byPercentage: 0.45)!, forState: .highlighted) //FIXME: IDK what is happening here with the color setting
        sendRequests.addTarget(self, action: #selector(sendFriendRequests), for: .touchUpInside)
    
        view.addSubview(sendRequests)
    }
    
    func prepareNoResults() {
		noResultsIndicator = UIView(frame: LayoutManager.belowCentered(elementAbove: navbar, padding: .PADDING, width: view.frame.width, height: view.frame.height/3));         view.addSubview(noResultsIndicator)

//		noResultsIndicator = UIView(frame: .zero); view.addSubview(noResultsIndicator)
//		noResultsIndicator.translatesAutoresizingMaskIntoConstraints = false
//		noResultsIndicator.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: .PADDING).isActive = true
//		noResultsIndicator.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
//		noResultsIndicator.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/3).isActive = true
//		noResultsIndicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
//        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 4 * .PADDING, height: view.frame.height/(3 * 1.5)))
        imgView.center = CGPoint(x: noResultsIndicator.frame.width/2, y: .PADDING * 3 + imgView.frame.height/2)
        imgView.image = .logo_dark
        imgView.contentMode = .scaleAspectFit
        noResultsIndicator.addSubview(imgView)

        
        let title = UILabel(frame: LayoutManager.belowCentered(elementAbove: imgView, padding: .MARGINAL_PADDING, width: imgView.frame.width, height: 40))
        title.font = .SUBTITLE_FONT
        title.textColor = .ACCENT_BLUE
        title.backgroundColor = .clear
        title.text = "Oops!"
        title.textAlignment = .center
        noResultsIndicator.addSubview(title)
        
        let sub = UITextView(frame: LayoutManager.belowCentered(elementAbove: title, padding: 0, width: title.frame.width, height: 60))
        sub.font = .TEXT_FONT
        sub.textColor = .white
        sub.backgroundColor = .clear
        sub.text = "We couldn't find who you're looking for. Try another name!"
        sub.textContainer.lineBreakMode = .byWordWrapping
        sub.textAlignment = .center
        sub.isScrollEnabled = false
        
        noResultsIndicator.alpha = 0
        noResultsIndicator.addSubview(sub)
        
    }
    
    func setNoResults(to: Bool) {
        if to {
            UIView.animate(withDuration: 0.25) {
                self.noResultsIndicator.alpha = 1
            }
        } else {
            self.noResultsIndicator.alpha = 0
        }
    }

}
