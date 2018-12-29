//
//  AnonPersonCell.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import iosManagers
import ChameleonFramework

class PersonCell: UITableViewCell {

    var profilePic: UIButton!
    var name: UILabel!
    var allowsSelect = true
    var status: UILabel!
    var statusData: FRIEND_STATUS?
    var blackBack: Bool = false
    var highlightedColor: UIColor!
    var ogColor: UIColor!
    
    var usr: User!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            contentView.backgroundColor = highlightedColor
        } else {
            contentView.backgroundColor = blackBack ? .black : .flatBlackDark
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if statusData != FRIEND_STATUS.selected {
            if selected && allowsSelect {
                contentView.backgroundColor = blackBack ? .flatBlackDark : .black
            } else {
                contentView.backgroundColor = blackBack ? .black : .flatBlackDark
            }
        } else {
            if selected {
                contentView.backgroundColor = blackBack ? .black : .flatBlackDark
            } else {
                contentView.backgroundColor = blackBack ? .flatBlackDark : .black
            }
        }
    }
    
    func setState(to: FRIEND_STATUS) {
        self.statusData = to
        switch to {
        case .unknown:
            status.text = ""
            return
        case .selected:
            contentView.backgroundColor = .black
            status.text = "✓"
            return
        case .pending:
            status.text = "pending"
            self.allowsSelect = false
            return
        case .existing:
            status.text = "friends"
            self.allowsSelect = false
            return
        case .currUser:
            status.text = "me"
            self.allowsSelect = false
            return
        }
    }
    
    func initializeCellFrom(data: User, size: CGSize, blackBack: Bool = false) {
        usr = data
        self.blackBack = blackBack
        let number = ((abs(CGFloat(usr.uid.hashValue))/pow(2,63)) * 180 * 10).truncatingRemainder(dividingBy: 180)

        
        let initals: String = String(self.usr.fullname.split(separator: " ").map { (sub) -> Substring in return sub.prefix(1)}.reduce("", +).prefix(2))
        
        
        contentView.backgroundColor = blackBack ? .black : .flatBlackDark
        
        highlightedColor = contentView.backgroundColor?.modified(withAdditionalHue: 0, additionalSaturation: 0, additionalBrightness: 0.1)
        
        profilePic = UIButton(frame: CGRect(x: .PADDING, y: 2 * .MARGINAL_PADDING, width: size.height - 4 * .MARGINAL_PADDING, height: size.height - 4 * .MARGINAL_PADDING))
        profilePic.setTitle(initals, for: .normal)
        profilePic.setTitleColor(.white, for: .normal)
        profilePic.titleLabel?.font = UIFont.TEXT_FONT?.bold
        profilePic.imageView?.contentMode = .scaleAspectFill
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        profilePic.clipsToBounds = true
        
        
        profilePic.setBackgroundColor(color: UIColor.ACCENT_RED.modified(withAdditionalHue: number, additionalSaturation: 0, additionalBrightness: 0), forState: .normal)
        
        self.contentView.addSubview(profilePic)
        
        name = UILabel(frame: CGRect(x: profilePic.frame.maxX + .PADDING, y: profilePic.frame.minY, width: size.width/2, height: profilePic.frame.height))
        name.textColor = .white
        name.font = .TEXT_FONT
        name.text = usr.fullname
        self.contentView.addSubview(name)
        
        status = UILabel(frame: CGRect(x: name.frame.maxX + .PADDING, y: name.frame.minY, width: size.width - (name.frame.maxX + .PADDING*2), height: name.frame.height))
        status.textColor = .ACCENT_BLUE
        status.font = .TEXT_FONT
        status.textAlignment = .right
        self.contentView.addSubview(status)
        
    }

}
