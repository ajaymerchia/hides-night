//
//  DateTimeVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/26/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import PDTSimpleCalendar
import ARMDevSuite

class DateTimeVC: PDTSimpleCalendarViewController, PDTSimpleCalendarViewDelegate {

    var currentChoice: UILabel!
    var currentDate: Date!
    var timeChooser: UIDatePicker!
    var targetIndexPath: IndexPath!
    
    var calendarContribution: Date!
    var pickerContribution: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CreateNavBar
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closePicker))

        // Do any additional setup after loading the view.
        calendarContribution = currentDate
        pickerContribution = currentDate
        
        // collection view edits
        self.collectionView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)! + 60, width: view.frame.width, height: view.frame.height * 3/4 - 100)
        self.collectionView.alpha = 0
        self.delegate = self
        self.weekdayHeaderEnabled = false
        self.weekdayTextType = .veryShort
        self.collectionView.backgroundColor = .black

        self.view.backgroundColor = .black
        self.firstDate = Date.init()
        
        
        
        
        PDTSimpleCalendarViewCell.appearance().backgroundColor = .black
        
        // label view
        currentChoice = UILabel(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: 60))
        currentChoice.textColor = .white
        currentChoice.text = myUtils.getFormattedDateAndTime(date: currentDate)
        currentChoice.textAlignment = .center
        currentChoice.font = .SUBTITLE_FONT
        currentChoice.alpha = 0
        
        view.addSubview(currentChoice)

        
        timeChooser = UIDatePicker(frame: LayoutManager.belowCentered(elementAbove: self.collectionView, padding: 0, width: view.frame.width, height: view.frame.height-self.collectionView.frame.maxY))
        timeChooser.datePickerMode = .time
        timeChooser.tintColor = .white
        timeChooser.minuteInterval = 5
        timeChooser.setValue(UIColor.white, forKey: "textColor")
        timeChooser.setDate(currentDate, animated: true)
        timeChooser.alpha = 0
        timeChooser.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        
        view.addSubview(timeChooser)
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.collectionView.removeFromSuperview()
//        self.view.addSubview(collectionView)
        
        let BSView = UIView(frame: view.frame)
        BSView.backgroundColor = .black
        view.addSubview(BSView)
        
        let border1 = UISuite.getBorder(forView: self.collectionView, thickness: 1, color: .ACCENT_BLUE, side: .Bottom)
        border1.alpha = 0
        view.addSubview(border1)
        
        let border2 = UISuite
			.getBorder(forView: self.collectionView, thickness: 1, color: .ACCENT_BLUE, side: .Top)
        border2.alpha = 0
        view.addSubview(border2)
        
        

        
        
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 5), at: .top, animated: false)
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        
//        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
        
//        UIView.animate(withDuration: 0.5) {
//            self.collectionView.alpha = 1
//            BSView.alpha = 0
//        }
//
        UIView.animate(withDuration: 0.45, animations: {
            self.collectionView.alpha = 1
            self.currentChoice.alpha = 1
            self.timeChooser.alpha = 1
            border1.alpha = 1
            border2.alpha = 1
            BSView.alpha = 0
        }) { (done) in
            BSView.removeFromSuperview()
            
            
            self.collectionView.selectItem(at: self.targetIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.bottom)
            
        }
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! PDTSimpleCalendarViewCell
        
        cell.circleSelectedColor = .ACCENT_BLUE
        cell.circleTodayColor = .flatGray()
        cell.circleDefaultColor = .black
        cell.textDisabledColor = .flatGrayDark()
        cell.textSelectedColor = .black
        
        cell.layer.borderWidth = 0
        cell.layer.shadowOpacity = 0
        
        if cell.date != nil {
            let order = Calendar.current.compare(currentDate, to: cell.date, toGranularity: .day)
            if order == .orderedSame {
                targetIndexPath = indexPath
            }
        }
        
        
        
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) as! PDTSimpleCalendarViewHeader
        cell.separatorColor = .black
        cell.textColor = .white
        cell.titleLabel.textColor = .ACCENT_BLUE
        cell.backgroundColor = .black
        return cell
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, shouldUseCustomColorsFor shouldUseCustomColorsForDate: Date?) -> Bool {
        return true
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, circleColorFor circleColorForDate: Date?) -> UIColor! {
        return .black
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, textColorFor textColorForDate: Date?) -> UIColor! {
        return .white
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, didSelect date: Date!) {
        calendarContribution = date
        updateDate()
    }
    
    
    
    @objc func timeChanged() {
        updateDate()
    }
    
    
    func updateDate() {
        pickerContribution = timeChooser.date.addingTimeInterval(-8 * 60 * 60)
        let combinedString = String(calendarContribution.description.prefix(10) + pickerContribution.description.suffix(from: pickerContribution.description.index(of: " ")!))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        currentDate = dateFormatter.date(from: String(combinedString.prefix(dateFormatter.dateFormat.count)))
        
        currentChoice.text = myUtils.getFormattedDateAndTime(date: currentDate)
        
    }
    
    @objc func closePicker() {
        (self.navigationController as! DataNavVC).date = currentDate
        self.navigationController?.popViewController(animated: true)
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
