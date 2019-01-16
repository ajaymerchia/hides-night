//
//  LocalData.swift
//
//  Created by Ajay Raj Merchia on 10/10/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit
class LocalData {
    static let defaultKey = LocalData("defaultKey")
    static let activeGameID = LocalData("activeGameID")
    static let activeTeamID = LocalData("activeTeamID")
    static let activeRoundID = LocalData("activeRoundID")
    
    var key_name: String!
    
    private init(_ key: String) {
        key_name = key
    }
    
    static func getLocalData(forKey: LocalData) -> String? {
        let defaults = UserDefaults.standard
        guard let str = defaults.string(forKey: forKey.key_name) else {
            return nil
        }
        return str
    }
    static func putLocalData(forKey: LocalData, data: String) {
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: forKey.key_name)
    }
    
    
    static func getLocalDataAsArr(forKey: LocalData) -> [String]? {
        let defaults = UserDefaults.standard
        guard let arr = defaults.array(forKey: forKey.key_name) as? [String] else {
            return nil
        }
        return arr
    }
    static func putLocalData(forKey: LocalData, data: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: forKey.key_name)
    }
    
    
    static func deleteLocalData(forKey: LocalData) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: forKey.key_name)
    }
    
}
