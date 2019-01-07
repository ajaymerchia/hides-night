//
//  RoundCell.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    var message: Message!
    var msgBackground: UILabel!
    var msgLabel: UILabel!
    
    var senderImage: UIImageView!
    
    var personImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    func initializeCellFrom(data: Message, size: CGSize, forPerspective: User, inGame: Game, withHeader: Bool) {
        self.message = data
        let messageByUser = message.senderID == forPerspective.uid
        
        var headerSpace: CGFloat = 0
        if withHeader {
            headerSpace = 15
        } else if !messageByUser {
            headerSpace = -5
        }
        let nameLabel = UILabel(frame: .zero)
        nameLabel.font = UIFont.LIGHT_TEXT_FONT?.withSize(11)
        nameLabel.textColor = .white
        
        if withHeader {
            self.contentView.addSubview(nameLabel)
        }
        
        let bubbleHeight = size.height - (headerSpace + 2 * .MARGINAL_PADDING)
        
        
        self.contentView.backgroundColor = .black
        
        
        
        
        
        msgBackground = UILabel(frame: CGRect(x: 0, y: 0, width: size.width * 0.75, height: bubbleHeight))
        msgBackground.font = UIFont.TEXT_FONT
        msgBackground.text = data.msg
        msgBackground.sizeToFit()

        if messageByUser {
            msgBackground.frame.size = CGSize(width: min(msgBackground.frame.width  + 2 * .PADDING, size.width * 0.75), height: bubbleHeight)
            msgBackground.frame.origin = CGPoint(x: size.width - (.PADDING + msgBackground.frame.width), y: headerSpace + .MARGINAL_PADDING)
            
            
            msgBackground.backgroundColor = .ACCENT_BLUE
            
            
        } else {
            
            let imageSize: CGFloat = 25
            
            senderImage = UIImageView(frame: CGRect(x: .PADDING, y: size.height - (imageSize + .MARGINAL_PADDING), width: imageSize, height: imageSize))
            for player in inGame.players {
                if player.uid == message.senderID {
                    senderImage.image = player.profilePic ?? .avatar_black
                    nameLabel.text = player.fullname
                }
            }
            senderImage.contentMode = .scaleAspectFill
            senderImage.layer.cornerRadius = senderImage.frame.width/2
            senderImage.clipsToBounds = true
            self.contentView.addSubview(senderImage)
            
            msgBackground.frame.size = CGSize(width: min(msgBackground.frame.width  + 2 * .PADDING, size.width * 0.75), height: bubbleHeight)
            msgBackground.frame.origin = CGPoint(x: senderImage.frame.maxX + .MARGINAL_PADDING, y: headerSpace + .MARGINAL_PADDING)
            
            
            msgBackground.backgroundColor = .flatBlackDark
            nameLabel.frame = CGRect(x: msgBackground.frame.minX, y: 0, width: contentView.frame.width, height: headerSpace)
        }
        
        
        msgBackground.layer.cornerRadius = 10
        msgBackground.clipsToBounds = true
        msgBackground.text = ""
        
        msgLabel = UILabel(frame: msgBackground.frame)
        msgLabel.frame = CGRect(x: msgBackground.frame.minX + .PADDING, y: msgBackground.frame.minY, width: msgBackground.frame.width - 2 * .PADDING, height: msgBackground.frame.height)
        
        msgLabel.font = UIFont.TEXT_FONT
        msgLabel.text = message.msg
        msgLabel.textColor = messageByUser ? .black : .offWhite
        
        msgLabel.lineBreakMode = .byWordWrapping
        msgLabel.numberOfLines = 0
        msgLabel.textAlignment = .left
        
        
        if let img = message.img {
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width - .PADDING/2, height: bubbleHeight - .PADDING/2))
            msgBackground.frame.size = CGSize(width: size.width, height: bubbleHeight)
            
            
            imgView.layer.cornerRadius = 10
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            
            self.msgBackground.addSubview(imgView)
            imgView.center = CGPoint(x: msgBackground.frame.width/2, y: msgBackground.frame.height/2)
            imgView.image = img
            
            if messageByUser {
                msgBackground.frame.origin = CGPoint(x: contentView.frame.width - (.PADDING + msgBackground.frame.width), y: msgBackground.frame.minY)
            }
            
        }
        
        
        
        self.contentView.addSubview(msgBackground)
        self.contentView.addSubview(msgLabel)
        
        
        
    }

    
    
}
