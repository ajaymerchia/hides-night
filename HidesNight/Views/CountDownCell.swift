//
//  CountDownCell.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/10/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit
import CountdownLabel
import iosManagers

class CountDownCell: UITableViewCell {
    
    var interval: TimeInterval!
    
    var titleLabel: UILabel!
    var countdown: CountdownLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
        return
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        //
        return
    }
    
    
    func initializeCellFrom(time: TimeInterval, title: String, size: CGSize) {
        self.interval = time
        contentView.backgroundColor = .black
        
        titleLabel = UILabel(frame: CGRect(x: .PADDING, y: .MARGINAL_PADDING, width: size.width - .PADDING, height: 25))
        titleLabel.font = UIFont.TEXT_FONT
        titleLabel.text = title
        titleLabel.textColor = .white
        
        self.contentView.addSubview(titleLabel)
        
        countdown = CountdownLabel(frame: LayoutManager.belowLeft(elementAbove: titleLabel, padding: .MARGINAL_PADDING, width: size.width - 2 * .PADDING, height: 60), minutes: time)
        countdown.pause()
        countdown.textAlignment = .center
        countdown.font = UIFont.TITLE_FONT
        countdown.textColor = .white
        
        self.contentView.addSubview(countdown)
        
        
        
    }

}
