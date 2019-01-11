//
//  RoundCell.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit

class RoundCell: UITableViewCell {

    
    var round: Round!
    var roundNum: UIButton!
    var roundName: UILabel!
    
    var highlightedColor: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlightedColor == nil {
            highlightedColor = contentView.backgroundColor?.modified(withAdditionalHue: 0, additionalSaturation: 0, additionalBrightness: 0.1)
        }
        
        if highlighted {
            contentView.backgroundColor = highlightedColor
        } else {
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            contentView.backgroundColor = .flatBlackDark
        } else {
            contentView.backgroundColor = .black
        }
    }
    
    func initializeCellFrom(data: Round, size: CGSize) {
        self.round = data
        
        
        
        contentView.backgroundColor = .flatBlackDark
        
        
        roundNum = UIButton(frame: CGRect(x: .PADDING, y: 2 * .MARGINAL_PADDING, width: size.height - 4 * .MARGINAL_PADDING, height: size.height - 4 * .MARGINAL_PADDING))
        roundNum.setTitle("\(round.order!).", for: .normal)
        roundNum.setTitleColor(.white, for: .normal)
        roundNum.titleLabel?.font = UIFont.SUBTITLE_FONT
        
        roundNum.layer.cornerRadius = roundNum.frame.width/2
        roundNum.clipsToBounds = true
        roundNum.isUserInteractionEnabled = false
        
        self.contentView.addSubview(roundNum)
        
        
        
        let textOfCell = UIView(frame: CGRect(x: roundNum.frame.maxX + .PADDING, y: 0, width: size.width - (roundNum.frame.maxX + .PADDING + roundNum.frame.minX), height: 30))
        
        roundName = UILabel(frame: CGRect(x: 0, y: 0, width: textOfCell.frame.width, height: 30))
        roundName.textColor = .white
        roundName.font = .BIG_TEXT_FONT
        roundName.text = self.round.name
        textOfCell.addSubview(roundName)
        
        
        textOfCell.center = CGPoint(x: textOfCell.frame.midX, y: size.height/2)
        
        self.contentView.addSubview(textOfCell)
        
    }
    

}
