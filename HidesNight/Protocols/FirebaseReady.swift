//
//  FirebaseReady.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/21/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
protocol FirebaseReady {
    func createPushable() -> [String : Any?]
    init(key: String, record: [String: Any?])
}
