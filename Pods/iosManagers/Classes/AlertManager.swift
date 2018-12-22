//
//  AlertManager.swift
//
//  Created by Ajay Raj Merchia on 10/10/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

public class AlertManager {
    private var srcView:UIViewController!
    private var callback:(() -> ())?
    public init(view: UIViewController) {
        srcView = view
    }
    public init(view: UIViewController, stateRestoration: @escaping (() -> ()) ) {
        srcView = view
        callback = stateRestoration
    }
    
    public func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        srcView.present(alert, animated: true, completion: nil)
        callback?()
    }
    

    public func yesOrNo(title: String, message: String, yes: @escaping () -> (), no: @escaping () -> () ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            yes()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (_) in
            no()
        }))
        
        srcView.present(alert, animated: true, completion: nil)
        
    }
    
    public func startProgressHud(withMsg:String) -> JGProgressHUD {
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = withMsg
        hud.show(in: self.srcView.view)
        return hud
    }
    
    public func getTextInput(withTitle: String, andPlaceholder: String, placeholderToText: Bool = false,  completion: @escaping (String) -> (), cancellation: @escaping () -> () = {}) {
        let alert = UIAlertController(title: withTitle, message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            if placeholderToText {
                textField.text = andPlaceholder
            } else {
                textField.placeholder = andPlaceholder

            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            _ in
            cancellation()
        }))
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            guard let response = alert.textFields?.first?.text else {
                cancellation()
                return
            }
            completion(response)
        }))
        
        srcView.present(alert, animated: true)
        
        
    }
    
    
    
}
