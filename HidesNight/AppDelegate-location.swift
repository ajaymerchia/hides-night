//
//  AppDelegate-location.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/15/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import CoreLocation

extension AppDelegate: CLLocationManagerDelegate {
    func setUpLocationManagerSubscriber() {
        
        
        let locationManager = CLLocationManager()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        updateLocationFrom(manager: locationManager)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateLocationFrom(manager: manager)
        
    }
    
    func updateLocationFrom(manager: CLLocationManager) {
        guard let gameID = LocalData.getLocalData(forKey: .activeGameID) else { return }
        guard let teamID = LocalData.getLocalData(forKey: .activeTeamID) else { return }
        guard let roundID = LocalData.getLocalData(forKey: .activeRoundID) else { return }
        guard let newLocation = manager.location else { return }
                
        FirebaseAPIClient.updateLocationFor(inRound: roundID, teamID: teamID, forGame: gameID, toLocation: newLocation, completion: {})
    }
    
    
    
}
