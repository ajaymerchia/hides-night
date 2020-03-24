//
//  CreateGameVC-initUI.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension CreateGameVC {
    func initUI() {
        self.view.backgroundColor = .black
        initNav()
        initCreateButton()
        initTableview()
        initMetadataCells()
        initGameParameters()
        initTeamParameters()
        
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(goBack))
        
        self.navigationItem.title = editMode ? "Edit Game" : "Create a Game"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createGame))
        
    }
    
    func initTableview() {
        tableview = UITableView(frame: LayoutManager.belowCentered(elementAbove: navbar, padding: 0, width: view.frame.width, height: view.frame.height - (navbar.frame.maxY + createButton.frame.height)))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .black
        tableview.separatorStyle = .none
//        tableview.isScrollEnabled = false
//        tableview.separatorColor = .white
        
        tableview.showsVerticalScrollIndicator = false
        
        view.addSubview(tableview)
        
        eventImageHeader = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/3))
        eventImageHeader.contentMode = .scaleAspectFill
        eventImageHeader.clipsToBounds = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        eventImageHeader.addGestureRecognizer(recognizer)
        
        
    }
    
    @objc func hideKeyboard() {
        eventNameField.resignFirstResponder()
    }
    
    func initMetadataCells() {
        // EventName
        let inset: CGFloat = 7
        
        eventNameCell.contentView.backgroundColor = cellColor
        eventNameField = UITextField(frame: CGRect(x: .PADDING, y: 10, width: view.frame.width - 5 * .PADDING, height: heightComputer(indexPath: ind(0, 0)) - 10))
        eventNameField.font = .BIG_TEXT_FONT
        eventNameField.textColor = .white
        eventNameField.tintColor = .white
        eventNameField.attributedPlaceholder = NSAttributedString(string: "Game Title (e.g. Sir Hides-a-Lot)", attributes: [.font: UIFont.BIG_TEXT_FONT, .foregroundColor: UIColor.flatWhiteDark()])
        eventNameField.becomeFirstResponder()

        
        
        addImageButton = UIButton(frame: CGRect(x: eventNameField.frame.maxX + .PADDING, y: 0, width: 2 * .PADDING, height: 2 * .PADDING))
        addImageButton.center = CGPoint(x: addImageButton.frame.midX, y: heightComputer(indexPath: ind(0, 0))/2)
        addImageButton.setBackgroundColor(color: .clear, forState: .normal)
        addImageButton.layer.borderColor = UIColor.white.cgColor
        addImageButton.layer.borderWidth = 1
        
        addImageButton.setImage(UIImage.nav_add_image.withRenderingMode(.alwaysTemplate), for: .normal)
        addImageButton.imageView?.tintColor = .white
        addImageButton.imageView?.contentMode = .scaleAspectFit
        addImageButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        
        addImageButton.layer.cornerRadius = addImageButton.frame.width/2
        addImageButton.clipsToBounds = true
        
        addImageButton.addTarget(self, action: #selector(requestEventImage), for: .touchUpInside)
        
        
        eventNameCell.addSubview(eventNameField)
        eventNameCell.addSubview(addImageButton)
        
        let eventNameCellBorder = UIView(frame: CGRect(x: 0, y: heightComputer(indexPath: ind(0, 0)) - 1, width: view.frame.width, height: 1))
        eventNameCellBorder.backgroundColor = separatorColor
        
        eventNameCell.addSubview(eventNameCellBorder)
        
        // event Date
        dateTimeCell.contentView.backgroundColor = cellColor
        dateTimeCell.textLabel?.text = "Game Date & Time"
        dateTimeCell.textLabel?.textColor = .white
        dateTimeCell.textLabel?.font = .TEXT_FONT
        
        dateTimeCell.detailTextLabel?.text = myUtils.getFormattedDateAndTime(date: self.date)
        dateTimeCell.detailTextLabel?.textColor = .white
        dateTimeCell.detailTextLabel?.font = .LIGHT_TEXT_FONT
        let dateTimeCellBorder = UIView(frame: CGRect(x: 0, y: heightComputer(indexPath: ind(0, 1)) - 1, width: view.frame.width, height: 1))
        dateTimeCellBorder.backgroundColor = separatorColor
        dateTimeCell.addSubview(dateTimeCellBorder)
    }
    
    func initGameParameters() {
        roundDurationCell.contentView.backgroundColor = cellColor
        

            let roundDurationTitle = UILabel(frame: CGRect(x: .PADDING, y: 0, width: (view.frame.width - 2 * .PADDING)/2, height: 40))
            roundDurationTitle.text = "Round Duration"
            roundDurationTitle.textColor = .white
            roundDurationTitle.font = .TEXT_FONT
            roundDurationCell.addSubview(roundDurationTitle)
        
            roundDurationLabel = UILabel(frame: CGRect(x: roundDurationTitle.frame.maxX, y: 0, width: (view.frame.width - 2 * .PADDING)/2, height: 40))
            roundDurationLabel.textAlignment = .right
            roundDurationLabel.textColor = .white
            roundDurationLabel.font = .LIGHT_TEXT_FONT
            update(label: roundDurationLabel, withInterval: roundDuration)
            roundDurationCell.addSubview(roundDurationLabel)
            labels.append(roundDurationLabel)
        
        
            let roundDurationPicker = getDatePicker(underLabel: roundDurationLabel)
            roundDurationPicker.tag = 0
            roundDurationPicker.countDownDuration = roundDuration
            roundDurationPicker.addTarget(self, action: #selector(durationDidChange(_:)), for: .valueChanged)
        
            durationPickers.append(roundDurationPicker)
        
        
        checkInDurationCell.contentView.backgroundColor = cellColor
        
        
            let checkInDurationTitle = UILabel(frame: CGRect(x: .PADDING, y: 0, width: (view.frame.width - 2 * .PADDING)/2, height: 40))
            checkInDurationTitle.text = "Check-In Duration"
            checkInDurationTitle.textColor = .white
            checkInDurationTitle.font = .TEXT_FONT
            checkInDurationCell.addSubview(checkInDurationTitle)
        
            checkInDurationLabel = UILabel(frame: CGRect(x: checkInDurationTitle.frame.maxX, y: 0, width: (view.frame.width - 2 * .PADDING)/2, height: 40))
            checkInDurationLabel.textAlignment = .right
            checkInDurationLabel.textColor = .white
            checkInDurationLabel.font = .LIGHT_TEXT_FONT
            update(label: checkInDurationLabel, withInterval: checkInDuration)
            checkInDurationCell.addSubview(checkInDurationLabel)
            labels.append(checkInDurationLabel)
        
            let checkInDurationPicker = getDatePicker(underLabel: checkInDurationLabel)
            checkInDurationPicker.tag = 1
            checkInDurationPicker.countDownDuration = checkInDuration
            checkInDurationPicker.addTarget(self, action: #selector(durationDidChange(_:)), for: .valueChanged)
            durationPickers.append(checkInDurationPicker)
        
        
        
        gpsActivationCell.contentView.backgroundColor = cellColor
        
        
            let gpsActivationTitle = UILabel(frame: CGRect(x: .PADDING, y: 0, width: (view.frame.width - 2 * .PADDING)/2, height: 40))
            gpsActivationTitle.text = "GPS Activation after: "
            gpsActivationTitle.textColor = .white
            gpsActivationTitle.font = .TEXT_FONT
            gpsActivationCell.addSubview(gpsActivationTitle)
        
            gpsActivationLabel = UILabel(frame: CGRect(x: gpsActivationTitle.frame.maxX, y: 0, width: (view.frame.width - 2 * .PADDING)/2, height: 40))
            gpsActivationLabel.textAlignment = .right
            gpsActivationLabel.textColor = .white
            gpsActivationLabel.font = .LIGHT_TEXT_FONT
            update(label: gpsActivationLabel, withInterval: gpsActivation)
            gpsActivationCell.addSubview(gpsActivationLabel)
            labels.append(gpsActivationLabel)
        
            let gpsActivationPicker = getDatePicker(underLabel: gpsActivationLabel)
            gpsActivationPicker.tag = 2
            gpsActivationPicker.countDownDuration = gpsActivation
            gpsActivationPicker.addTarget(self, action: #selector(durationDidChange(_:)), for: .valueChanged)
            durationPickers.append(gpsActivationPicker)
        
        for i in 0..<allCells[1].count {
            let picker = durationPickers[i]
            picker.alpha = 0
            allCells[1][i].addSubview(picker)
            allBorders.append(addTopBottomBorder(toCell: allCells[1][i], indexPath: ind(1,i)))
            
        }
        
    }
    
    func initTeamParameters() {
        // event Date
        teamDecisionCell.contentView.backgroundColor = cellColor
        teamDecisionCell.textLabel?.text = "Who Chooses the Teams?"
        teamDecisionCell.textLabel?.textColor = .white
        teamDecisionCell.textLabel?.font = .TEXT_FONT
        
        teamDecisionCell.detailTextLabel?.text = teamDecisionType.description
        teamDecisionCell.detailTextLabel?.textColor = .white
        teamDecisionCell.detailTextLabel?.font = .LIGHT_TEXT_FONT
        let teamDecisionCellBorder = UIView(frame: CGRect(x: 0, y: heightComputer(indexPath: ind(2, 0)) - 1, width: view.frame.width, height: 1))
        teamDecisionCellBorder.backgroundColor = separatorColor
        teamDecisionCell.addSubview(teamDecisionCellBorder)
        
        seekDecisionCell.contentView.backgroundColor = cellColor
        seekDecisionCell.textLabel?.text = "Who Chooses the Seekers?"
        seekDecisionCell.textLabel?.textColor = .white
        seekDecisionCell.textLabel?.font = .TEXT_FONT
        
        seekDecisionCell.detailTextLabel?.text = seekDecisionType.description
        seekDecisionCell.detailTextLabel?.textColor = .white
        seekDecisionCell.detailTextLabel?.font = .LIGHT_TEXT_FONT
        let seekDecisionCellBorder = UIView(frame: CGRect(x: 0, y: heightComputer(indexPath: ind(2, 0)) - 1, width: view.frame.width, height: 1))
        seekDecisionCellBorder.backgroundColor = separatorColor
        seekDecisionCell.addSubview(seekDecisionCellBorder)
    }
    
    func getDatePicker(underLabel: UILabel) -> UIDatePicker{
        let datePicker = UIDatePicker(frame: CGRect(x: .PADDING, y: underLabel.frame.maxY + .PADDING * 2, width: view.frame.width - 2 * .PADDING, height: 80))
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = .countDownTimer
        datePicker.minuteInterval = 5
        
        
        return datePicker
    }

    
    
    func addTopBottomBorder(toCell: UITableViewCell, indexPath: IndexPath) -> [UIView] {
        let top = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        top.backgroundColor = separatorColor
        top.alpha = 1
        toCell.addSubview(top)
        
        let bottom = UIView(frame: CGRect(x: 0, y: heightComputer(indexPath: indexPath) - 1, width: view.frame.width, height: 1))
        bottom.backgroundColor = separatorColor
        bottom.alpha = 0
        toCell.addSubview(bottom)
        
        return [top, bottom]
    }
    
    func initCreateButton() {
        createButton = UIButton(frame: CGRect(x: 0, y: view.frame.height - (80), width: view.frame.width, height: 80))
        createButton.setBackgroundColor(color: .ACCENT_BLUE, forState: .normal)
        createButton.setTitle("Create Game!", for: .normal)
        createButton.titleLabel?.font = .SUBTITLE_FONT
        createButton.addTarget(self, action: #selector(createGame), for: .touchUpInside)
        view.addSubview(createButton)
    }
    
    
}
