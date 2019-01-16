//
//  InstructionsVC-data.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/23/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers

extension InstructionsVC {
    func createSlides() {
        self.slideData = []
        
        var _: [String] = ["Splitting Up", "Beware the GPS", "Getting Caught"]
        slideData.append(SlideData(header: "Find your Group!",
                                       detail: "Hides Night is best with friends! We recommend 8+ players, where players will work in teams of 2 to hide from seekers.",
                                       image: .instruct_findGroup))
        slideData.append(SlideData(header: "Creating a Game",
                                       detail: "Select an admin to create a game. They will be responsible for finalizing teams, deciding the zone, and the length of the game.",
                                       image: .instruct_adminSelect))
        slideData.append(SlideData(header: "Hide & Seek",
                                       detail: "Depending on the size of the zone, seekers will take 5-10 minutes to let other players hide. Stay hidden! Teams can't split up.",
                                       image: .instruct_hideAndSeek))
        slideData.append(SlideData(header: "Getting Caught",
                                   detail: "When the seekers catch a team, they have to tag one of the members and send a photo to the chat. Once found, hiders join seekers.",
                                   image: .instruct_caught))
        slideData.append(SlideData(header: "GPS Activation",
                                   detail: "Depending on the Game Admin, your phone's GPS may broadcast your location to other teams. Shelter in place or keep moving!",
                                   image: .instruct_gps))
        slideData.append(SlideData(header: "Winning",
                                       detail: "The game ends if seekers are unable to find ALL groups before the timer expires. Otherwise, any teams still hidden win!",
                                       image: .instruct_win))
    }
    


}
