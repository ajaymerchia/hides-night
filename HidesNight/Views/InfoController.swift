//
//  InfoController.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/28/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers

public class InfoController: UIView, UIGestureRecognizerDelegate {
    
    public var outlineColor: UIColor = .white
    public var outlineThickness: CGFloat = 0.5
    
    public var cornerRadius: CGFloat = 20
    public var topPadding: CGFloat = .PADDING
    
    public var imageView = UIImageView()
    public var image: UIImage?
    
    public var titleLabel = UILabel()
    public var titleText = ""
    public var titleFont: UIFont = UIFont.SUBTITLE_FONT!
    public var titleColor: UIColor = .white
    public var titleLabelHeight: CGFloat = 30
    
    public var detailLabel = UILabel()
    public var detailText = ""
    public var detailFont: UIFont = UIFont.BIG_TEXT_FONT!
    public var detailColor: UIColor = .white
    
    public var actionButton = UIButton()
    public var actionText = ""
    public var actionColor: UIColor = .ACCENT_RED
    public var actionFont: UIFont = UIFont.BIG_TEXT_FONT!.bold
    public var actionCallback: () -> () = {}
    
    public var finalCallback: () -> () = {}
    
    private var dismissIcon: UIButton!
    
    private var presentedView: UIView!
    
    private var overlay: UIView!
    private var gestureRestrictor: UITapGestureRecognizer!
    
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = .flatBlackDark
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentIn(view: UIView) {
        self.presentedView = view
        self.overlay = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        self.overlay.backgroundColor = .black
        self.overlay.alpha = 0.0
        view.addSubview(overlay)
        
        
        self.frame = CGRect(x: 0, y: 0, width: min(view.frame.width - 4 * .PADDING, 400), height: view.frame.height) // Trim height after all elements added
        
        
        // setup shape
        self.layer.borderColor = outlineColor.cgColor
        self.layer.borderWidth = outlineThickness
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
        let dismissSize: CGFloat = 20
        self.dismissIcon = UIButton(frame: CGRect(x: self.frame.width - (dismissSize +
            .PADDING), y: .PADDING, width: dismissSize, height: dismissSize))
        self.dismissIcon.setTitle("x", for: .normal)
        self.dismissIcon.setTitleColor(.white, for: .normal)
        self.dismissIcon.titleLabel?.font = .SUBTITLE_FONT
        self.dismissIcon.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        self.addSubview(dismissIcon)
        
        // create top padding & reference for layout manager
        var lastView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: topPadding))
        lastView.alpha = 0
        self.addSubview(lastView)
        
        // if has image, add the image as a circle in the middle
        if let img = image {
            imageView.alpha = 1
            imageView.frame = LayoutManager.belowCentered(elementAbove: lastView, padding: 0, width: self.frame.width/1.5, height: self.frame.width/1.5)
            imageView.image = img
            imageView.layer.cornerRadius = imageView.frame.width/2
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            self.addSubview(imageView)
            lastView = imageView
        } else {
            imageView.alpha = 0
        }
        
        if titleText != "" {
            titleLabel.alpha = 1
            titleLabel.frame = LayoutManager.belowCentered(elementAbove: lastView, padding: .PADDING, width: self.frame.width, height: titleLabelHeight)
            titleLabel.font = titleFont
            titleLabel.textColor = titleColor
            titleLabel.text = titleText
            titleLabel.textAlignment = .center
            
            self.addSubview(titleLabel)
            lastView = titleLabel
        } else {
            titleLabel.alpha = 0
        }
        
        if detailText != "" {
            detailLabel.alpha = 1
            detailLabel.frame = LayoutManager.belowCentered(elementAbove: lastView, padding: 0, width: self.frame.width, height: 20)
            detailLabel.font = detailFont
            detailLabel.textColor = detailColor
            detailLabel.text = detailText
            detailLabel.textAlignment = .center
            
            self.addSubview(detailLabel)
            lastView = detailLabel
        } else {
            detailLabel.alpha = 0
        }
        
        
        if actionText != "" {
            actionButton.alpha = 1
            actionButton.frame = LayoutManager.belowCentered(elementAbove: lastView, padding: .PADDING/2, width: self.frame.width, height: 40)
            
            actionButton.setTitle(actionText, for: .normal)
            actionButton.setTitleColor(actionColor, for: .normal)
            actionButton.setBackgroundColor(color: .black, forState: .highlighted)
            actionButton.titleLabel?.font = actionFont
            actionButton.addTarget(self, action: #selector(actionFunction), for: .touchUpInside)
            
            self.addSubview(actionButton)
            lastView = actionButton
            
        } else {
            actionButton.alpha = 0
            lastView = UIView(frame: LayoutManager.belowCentered(elementAbove: lastView, padding: .PADDING/2, width: self.frame.width, height: 40))
        }
        
        let largestDistance = self.subviews.map({(view) -> CGFloat in return view.frame.maxY}).reduce(0) { (res, nxt) -> CGFloat in
            return max(res, nxt)
        }
        
        self.frame = CGRect(x: 0, y: 0, width: min(view.frame.width - 4 * .PADDING, 400), height: largestDistance) // Trim height
        
        self.center = CGPoint(x: view.frame.midX, y: view.frame.maxY + .PADDING + self.frame.height/2)
        
        view.addSubview(self)
        
        
        gestureRestrictor = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        gestureRestrictor.delegate = self
        view.addGestureRecognizer(gestureRestrictor)
        
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 8, options: .curveEaseIn, animations: {
            self.center = CGPoint(x: view.frame.midX, y: view.frame.height/2.5)
            self.overlay.alpha = 0.7
            
        }, completion: nil)
        
    }
    
    @objc func dismiss() {
        
        UIView.animate(withDuration: 0.75, delay: 0.0, options: .curveEaseInOut, animations: {
            self.overlay.alpha = 0.0
        }) { (bool) in
            self.overlay.removeFromSuperview()
            self.presentedView.removeGestureRecognizer(self.gestureRestrictor)
            
            
        }
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: -8, options: .curveEaseIn, animations: {
//            self.overlay.alpha = 0.7
            self.center = CGPoint(x: self.presentedView.frame.midX, y: self.presentedView.frame.maxY + .PADDING + self.frame.height/2)
        }, completion: { (bool) in
            self.removeFromSuperview()
        })
        
        finalCallback()
        
    }
    
    @objc private func actionFunction() {
        actionCallback()
        dismiss()
    }
    
    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self) == true {
            return false
        }
        return true
    }
    
    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer != gestureRestrictor {
            return false
        }
        return true
    }
    
    
    
    
    
    
}
