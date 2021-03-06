//
//  FirebaseAPIClient.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class FirebaseAPIClient {
    // Account Creation
    static func createAccount(withEmail: String, andPassword: String, success: @escaping (AuthDataResult) -> (), fail: @escaping () -> ()) {
        
        debugPrint("Creating account for " + withEmail)
        Auth.auth().createUser(withEmail: withEmail, password: andPassword) { (auth, err) in
            if let error = err {
                debugPrint(error)
                fail()
                return
            }
            guard let authObj = auth else {
                fail()
                return
            }
            success(authObj)
        }
    }
    
    static func uploadUser(usr: User, withPhoto: Bool = false, completion: @escaping () -> (), fail: @escaping () -> ()) {
        // If uploading the photo, asynchronously attempt to do so. Ignore result
        if withPhoto {
            guard let img = usr.profilePic else {
                fail()
                return
            }
            uploadProfileImage(forUsername: usr.username, withImage: img, success: {}, fail: {})
        }
        
        // Register the user in the public domain
        let ref = Database.database().reference()
        let publicDomain = ref.child("publicInfo")
        publicDomain.child(usr.username).setValue(usr.email) { (err, ref) in
            if let error = err {
                debugPrint(error)
                fail()
                return
            }
            updateRemoteUser(usr: usr, success: completion, fail: fail)
        }
    }
    
    static func updateRemoteUser(usr: User, success: @escaping () -> (), fail: @escaping () -> ()) {
        // If user successfully publicly registered, add user object to datanode.
        let ref = Database.database().reference()
        let userRef = ref.child("users")
        let val = usr.createPushable()
        
        userRef.child(usr.uid).setValue(val, withCompletionBlock: { (err, ref) in
            if let error = err {
                debugPrint(error)
                fail()
                return
            }
            success()
        })
    }
    
    static func updateLocalUserData(usr: User, completion: @escaping () -> ()) {
        let ref = Database.database().reference().child("users").child(usr.uid)
        
        ref.observeSingleEvent(of: .value) { (snap) in
            guard let data = snap.value as? [String: Any?] else {
                completion()
                return
            }
            usr.updateThisUser(key: usr.uid, record: data)
            completion()
        }
    }
    
    static func uploadProfileImage(forUsername: String, withImage: UIImage, success: @escaping () -> (), fail: @escaping () -> ()) {
        let image_directory = Storage.storage().reference().child("profileImages")
        let photoRef = image_directory.child(forUsername)
        guard let photoData = withImage.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        photoRef.putData(photoData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                debugPrint("error with photo upload")
                fail()
                return
            }
            success()
        }
    }
    
    
    // Logging In
    static func getAllAccounts(callback: @escaping ([String: String]) -> ()) {
        Database.database().reference().child("publicInfo").observeSingleEvent(of: .value) { (snap) in
            guard let accounts = snap.value as? [String: String] else {
                callback([:])
                return
            }
            callback(accounts)
        }
    }
    
    static func findEmail(forUsername: String, success: @escaping (String) -> (), fail: @escaping () -> ()) {
        Database.database().reference().child("publicInfo").child(forUsername).observeSingleEvent(of: .value) { (snap) in
            guard let email = snap.value as? String else {
                fail()
                return
            }
            success(email)
        }
    }
    
    static func login(withEmail: String, andPassword: String, success: @escaping (String) -> (), fail: @escaping () -> ()) {
        Auth.auth().signIn(withEmail: withEmail, password: andPassword) { (data, err) in
            if let error = err {
                debugPrint(error)
                fail()
                return
            }
            guard let user = data else {
                fail()
                return
            }
            success(user.user.uid)
        }
        
    }
    
    static func getProfilePhotoFor(user: User, completion: @escaping (UIImage?) -> ()) {
        let photoTarget = Storage.storage().reference().child("profileImages").child(user.username)
        photoTarget.getData(maxSize: 2 * 1024 * 1024, completion: { (data, err) in
            if let photoData = data {
                if let img = UIImage(data: photoData) {
                    completion(img)
                }
            } else {
                completion(nil)
            }
            
        })
    }
    
    static func getUserForAccount(withId: String, completion: @escaping (User?) -> ()) {
        let ref = Database.database().reference().child("users").child(withId)
        
        ref.observeSingleEvent(of: .value) { (snap) in
            guard let data = snap.value as? [String: Any?] else {
                completion(nil)
                return
            }
            let usr = User(key: withId, record: data)
            
            let photoTarget = Storage.storage().reference().child("profileImages").child(usr.username)
            photoTarget.getData(maxSize: 2 * 1024 * 1024, completion: { (data, err) in
                if let photoData = data {
                    if let img = UIImage(data: photoData) {
                        usr.setProfilePicture(to: img, updateRemote: false)
                    }
                }
                completion(usr)
            })
            
            
        }
    }
    
    static func getAllUsers(withIDs: [String], completion: @escaping ([User]) -> ()) {
        if withIDs.count == 0 {
            completion([])
        }
        var usersDownloaded: [User] = []
        var failedRequests = 0
        for accountID in withIDs {
            getUserForAccount(withId: accountID) { (usr) in
                if let user = usr {
                    usersDownloaded.append(user)
                } else {
                    failedRequests += 1
                }
                
                if usersDownloaded.count == withIDs.count - failedRequests {
                    completion(usersDownloaded)
                }
            }
        }
    }
    
    static func logout(user: User) {
        Database.database().reference().child("deviceTokens").child(user.uid).setValue(nil)
        
        for game in user.games {
            game.notificationDevices[user.uid] = nil
            FirebaseAPIClient.updateRemoteGame(game: game, success: {}, fail: {})
        }
        
        
        do {
            print("Attempting to log out")
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
}


