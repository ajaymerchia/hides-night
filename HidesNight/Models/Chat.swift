//
//  Chat.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/6/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import ARMDevSuite

class Chat: FirebaseReady {
    // Set this up so it can only load a Day at a time
    var messages = [String: [Message]]()
    var parentGameID: String!
    
    func createPushable() -> [String : Any?] {
        var ret:[String: Any?] = [:]
        
        var messagesPushable = [String: [String: Any?]]()
        for (_, dayOfMessages) in messages {
            for msg in dayOfMessages {
                messagesPushable[msg.uid] = msg.createPushable()
            }
        }
        
        ret["messages"] = messagesPushable
        
        return ret
    }
    
    required init(key: String, record: [String : Any?]) {
        self.parentGameID = key
        if let msgs = record["messages"] as? [String: [String: Any?]] {
            for (msgID, data) in msgs {
                let newMsg = Message(key: msgID, record: data)
                if messages[myUtils.getURLSafeDateFormat(date: newMsg.timeSent)] == nil {
                    messages[myUtils.getURLSafeDateFormat(date: newMsg.timeSent)] = []
                }
                messages[myUtils.getURLSafeDateFormat(date: newMsg.timeSent)]!.append(newMsg)
            }
        }
        
    }
    
    init(fromGame: Game) {
        parentGameID = fromGame.uid
    }
    
    
}

class Message: FirebaseReady, Comparable {
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.timeSent > rhs.timeSent
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func createPushable() -> [String : Any?] {
        var ret:[String: Any?] = [:]
        
        ret["time"] = timeSent.description
        ret["sender"] = senderID
        ret["msg"] = msg
        ret["img"] = (img != nil ? true : false)
        
        return ret
    }
    
    required init(key: String, record: [String : Any?]) {
        fatalError("Use alternative initializer")
    }
    
    init(key: String, record: [String : Any?], chat: Chat) {
        self.uid = key
        self.timeSent = (record["time"] as? String)?.toDateTime()
        self.senderID = record["sender"] as? String ?? ""
        
        self.msg = record["msg"] as? String
        
        if record["img"] as? Bool ?? false {
            // Load Image from Firebase Database
            imgPending = true
            FirebaseAPIClient.getImageFor(message: self, fromChat: chat, onComplete: {})
        }
    }
    
    var uid: String!
    var timeSent: Date!
    var senderID: String!
    
    var imgPending: Bool = false
    
    var msg: String?
    var img: UIImage? {
        didSet {
            imageLoaded()
        }
    }
    var imageLoaded: () -> () = {
        debugPrint("Image loaded for message")
    }
    
    
    init(msg: String, sender: User) {
        uid = LogicSuite.uuid()
        timeSent = Date()
        senderID = sender.uid
        
        self.msg = msg
    }
    
    init(img: UIImage, sender: User) {
        uid = LogicSuite.uuid()
        timeSent = Date()
        senderID = sender.uid
        
        self.img = img
    }
    
}
