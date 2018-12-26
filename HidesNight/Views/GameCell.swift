//
//  GameCell.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import iosManagers
import ChameleonFramework

class GameCell: UITableViewCell {
    
    var gamePhoto: UIButton!
    var name: UILabel!
    var status: UILabel!
    
    var game: Game!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            contentView.backgroundColor = contentView.backgroundColor?.modified(withAdditionalHue: 0, additionalSaturation: 0, additionalBrightness: 0.1)
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
    
    func initializeCellFrom(data: Game, size: CGSize) {
        self.game = data
        let number = ((abs(CGFloat(game.uid.hashValue))/pow(2,63)) * 180 * 10).truncatingRemainder(dividingBy: 180)
        
        
        let initals: String = "HN"
        
        contentView.backgroundColor = .flatBlackDark
        
        gamePhoto = UIButton(frame: CGRect(x: .PADDING, y: 2 * .MARGINAL_PADDING, width: size.height - 4 * .MARGINAL_PADDING, height: size.height - 4 * .MARGINAL_PADDING))
        gamePhoto.setTitle(initals, for: .normal)
        gamePhoto.setTitleColor(.white, for: .normal)
        gamePhoto.titleLabel?.font = UIFont.TEXT_FONT?.bold
        
        gamePhoto.layer.cornerRadius = gamePhoto.frame.width/2
        gamePhoto.clipsToBounds = true
        
        
        gamePhoto.setBackgroundColor(color: UIColor.ACCENT_RED.modified(withAdditionalHue: number, additionalSaturation: 0, additionalBrightness: 0), forState: .normal)
        
        self.contentView.addSubview(gamePhoto)
        
        name = UILabel(frame: CGRect(x: gamePhoto.frame.maxX + .PADDING, y: gamePhoto.frame.minY, width: size.width/2, height: gamePhoto.frame.height))
        name.textColor = .white
        name.font = .TEXT_FONT
        name.text = game.admin
        self.contentView.addSubview(name)
        
        status = UILabel(frame: CGRect(x: name.frame.maxX + .PADDING, y: name.frame.minY, width: size.width - (name.frame.maxX + .PADDING*2), height: name.frame.height))
        status.textColor = .ACCENT_BLUE
        status.font = .TEXT_FONT
        self.contentView.addSubview(status)
        
    }
    
}
