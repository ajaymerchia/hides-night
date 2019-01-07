//
//  ChatVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/6/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    var chat: Chat!
    var user: User!
    var game: Game!
    
    var navbar: UINavigationBar!
    var composeBar: UIView!

    let composeBarHeight:CGFloat = 70
    
    var addPhotoButton: UIButton!
    var composeTextField: UITextField!
    var sendButton: UIButton!
    
    var isImageSending = false
    var overlayImageView: UIImageView!
    
    var chatView: UITableView!
    var pureMessages = [Message]()
    
    
    var navbarBottom: CGFloat!
    var textfieldOffset: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        setupManagers()
        initUI()
        setUpNewMessageListener()
        
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
