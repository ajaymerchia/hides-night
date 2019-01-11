//
//  FirebaseAPI-chat.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/6/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

extension FirebaseAPIClient {
    
    static func send(message: Message, to: Chat, onsend: @escaping () -> ()) {
        
        let dateBucket = myUtils.getURLSafeDateFormat(date: message.timeSent)
        
        if to.messages[dateBucket] == nil {
            to.messages[dateBucket] = []
        }
        
        to.messages[dateBucket]!.append(message)
        let chatNode = Database.database().reference().child("chats").child(to.parentGameID).child(dateBucket)
        
        let values = [message.uid: message.createPushable()]
        
        
        if let associatedPhoto = message.img {
            uploadImageFor(message: message, withImage: associatedPhoto, toChat: to) {
                chatNode.updateChildValues(values) { (err, ref) in
                    onsend()
                }
            }
        } else {
            chatNode.updateChildValues(values) { (err, ref) in
                onsend()
            }
        }
        
        
        
        
        
    }
    
    static func uploadImageFor(message: Message, withImage: UIImage, toChat: Chat, onComplete: @escaping () -> ()) {
        
        guard let photoData = withImage.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let photoRef = Storage.storage().reference().child("chats").child(toChat.parentGameID).child(message.uid)
        
        photoRef.putData(photoData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                debugPrint("error with photo upload")
                onComplete()
                return
            }
            onComplete()
        }
        
        
    }
    
    static func getImageFor(message: Message, fromChat: Chat, onComplete: @escaping () -> ()) {
        let photoTarget = Storage.storage().reference().child("chats").child(fromChat.parentGameID).child(message.uid)
        
        photoTarget.getData(maxSize: 2 * 1024 * 1024, completion: { (data, err) in
            if let photoData = data {
                if let img = UIImage(data: photoData) {
                    message.img = img
                    onComplete()
                }
            }
        })
        
    }
    
    static func loadChatFor(game: Game, onload: @escaping (Chat) -> ()) {
        let chatNode = Database.database().reference().child("chats").child(game.uid)
        
        let chatObject = Chat(fromGame: game)
        let todaySafe = myUtils.getURLSafeDateFormat(date: Date())
        
        // Load today's chats
        chatNode.child(todaySafe).observeSingleEvent(of: .value) { (snap) in
            guard let data = snap.value as? [String: [String: Any?]] else {
                onload(chatObject)
                return
            }
            
            for (uid, messageData) in data {
                let messageToAdd = Message(key: uid, record: messageData, chat: chatObject)
                
                if chatObject.messages[todaySafe] == nil {
                    chatObject.messages[todaySafe] = []
                }
                
                chatObject.messages[todaySafe]?.append(messageToAdd)
            }
            onload(chatObject)
        }
        
        // Indifferent Call to load the rest of the chats
        chatNode.observeSingleEvent(of: .value) { (snap) in
            guard let data = snap.value as? [String: [String: [String: Any?]]] else {
                return
            }
            
            for (dateRepr, dateMessages) in data {
                if dateRepr == todaySafe {
                    continue
                }
                
                for (uid, messageData) in dateMessages {
                    let messageToAdd = Message(key: uid, record: messageData, chat: chatObject)
                    if chatObject.messages[dateRepr] == nil {
                        chatObject.messages[dateRepr] = []
                    }
                    
                    chatObject.messages[dateRepr]?.append(messageToAdd)
                }
            }
            
            
        }
    }
 
    
    static func setUpNewMessageListenerFor(chat: Chat, onNewMessage: @escaping(Message) -> ()) {
        Database.database().reference().child("chats").child(chat.parentGameID).observe(.childChanged) { (snap) in
            
            guard let rawData = snap.value as? [String: [String: Any?]] else {
                return
            }
            
            for (uid, newMessageData) in rawData {
                let newMessage = Message(key: uid, record: newMessageData, chat: chat)
                let dateRepr = myUtils.getURLSafeDateFormat(date: newMessage.timeSent)
                
                if chat.messages[dateRepr] == nil {
                    chat.messages[dateRepr] = []
                }
                
                if !chat.messages[dateRepr]!.contains(newMessage) {
                    chat.messages[dateRepr]!.append(newMessage)

                }
                
                onNewMessage(newMessage)
            }
        }
        
        
        
        
    }
    
}
