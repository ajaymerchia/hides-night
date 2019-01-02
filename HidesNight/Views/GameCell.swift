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
    var team: Team!
    
    
    
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
        
        
        let initials: String = String(self.game.title.split(separator: " ").map { (sub) -> Substring in return sub.prefix(1)}.reduce("", +).prefix(2))
        
        
        contentView.backgroundColor = .flatBlackDark
        
        gamePhoto = UIButton(frame: CGRect(x: .PADDING, y: 2 * .MARGINAL_PADDING, width: size.height - 4 * .MARGINAL_PADDING, height: size.height - 4 * .MARGINAL_PADDING))
        gamePhoto.setTitle(initials, for: .normal)
        gamePhoto.setTitleColor(.white, for: .normal)
        gamePhoto.titleLabel?.font = UIFont.TEXT_FONT?.bold
        
        gamePhoto.layer.cornerRadius = gamePhoto.frame.width/2
        gamePhoto.clipsToBounds = true
        gamePhoto.imageView?.contentMode = .scaleAspectFill
        
        if let img = game.img {
            gamePhoto.setImage(img, for: .normal)
        }
        
        
        gamePhoto.setBackgroundColor(color: UIColor.ACCENT_RED.modified(withAdditionalHue: number, additionalSaturation: 0, additionalBrightness: 0), forState: .normal)
        
        self.contentView.addSubview(gamePhoto)
        
        
        
        let textOfCell = UIView(frame: CGRect(x: gamePhoto.frame.maxX + .PADDING, y: 0, width: size.width - (gamePhoto.frame.maxX + .PADDING + gamePhoto.frame.minX), height: 50 - .MARGINAL_PADDING))
        
        name = UILabel(frame: CGRect(x: 0, y: 0, width: textOfCell.frame.width, height: 30))
        name.textColor = .white
        name.font = .BIG_TEXT_FONT
        name.text = game.title
        textOfCell.addSubview(name)
        
        status = UILabel(frame: LayoutManager.belowCentered(elementAbove: name, padding: -.MARGINAL_PADDING, width: textOfCell.frame.width, height: 20))
        status.textColor = .ACCENT_BLUE
        status.font = .LIGHT_TEXT_FONT
        status.text = myUtils.getMDDYYRepr(date: game.datetime)
        textOfCell.addSubview(status)
        textOfCell.center = CGPoint(x: textOfCell.frame.midX, y: size.height/2)
        
        self.contentView.addSubview(textOfCell)
        
    }
    
    func initializeCellFrom(data: Team, size: CGSize) {
        self.team = data
        let number = ((abs(CGFloat(team.uid.hashValue))/pow(2,63)) * 180 * 10).truncatingRemainder(dividingBy: 180)
        
        
        let initials: String = String(self.team.name.split(separator: " ").map { (sub) -> Substring in return sub.prefix(1)}.reduce("", +).prefix(2))
        
        
        contentView.backgroundColor = .flatBlackDark
        
        gamePhoto = UIButton(frame: CGRect(x: .PADDING, y: 2 * .MARGINAL_PADDING, width: size.height - 4 * .MARGINAL_PADDING, height: size.height - 4 * .MARGINAL_PADDING))
        gamePhoto.setTitle(initials, for: .normal)
        gamePhoto.setTitleColor(.white, for: .normal)
        gamePhoto.titleLabel?.font = UIFont.TEXT_FONT?.bold
        
        gamePhoto.layer.cornerRadius = gamePhoto.frame.width/2
        gamePhoto.clipsToBounds = true
        gamePhoto.imageView?.contentMode = .scaleAspectFill
        
        if let img = self.team.img {
            gamePhoto.setImage(img, for: .normal)
        }
        
        
        gamePhoto.setBackgroundColor(color: UIColor.ACCENT_RED.modified(withAdditionalHue: number, additionalSaturation: 0, additionalBrightness: 0), forState: .normal)
        
        self.contentView.addSubview(gamePhoto)
        
        
        
        let textOfCell = UIView(frame: CGRect(x: gamePhoto.frame.maxX + .PADDING, y: 0, width: size.width - (gamePhoto.frame.maxX + .PADDING + gamePhoto.frame.minX), height: 50 - .MARGINAL_PADDING))
        
        name = UILabel(frame: CGRect(x: 0, y: 0, width: textOfCell.frame.width, height: 30))
        name.textColor = .white
        name.font = .BIG_TEXT_FONT
        name.text = self.team.name
        textOfCell.addSubview(name)
        
        status = UILabel(frame: LayoutManager.belowCentered(elementAbove: name, padding: -.MARGINAL_PADDING, width: textOfCell.frame.width, height: 20))
        status.textColor = .ACCENT_BLUE
        status.font = .LIGHT_TEXT_FONT
        status.text = [String](self.team.memberIDs.values).sorted().map({ (str) -> String in
            return "@" + str
        }).reduce("", { (curr, next) -> String in
            if curr == "" {
                return next
            }
            return curr + ", " + next
        })
        textOfCell.addSubview(status)
        textOfCell.center = CGPoint(x: textOfCell.frame.midX, y: size.height/2)
        
        self.contentView.addSubview(textOfCell)
        
    }
    
}
