//
//  RoundDetailVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/29/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import MapKit
import CoreLocation
import iosManagers
import JGProgressHUD


extension RoundDetailVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.mapView) == true {
            if touch.view is MKPinAnnotationView || hasCalloutSelected {
                return false
            }
            return true
        }
        return false
    }
    
    @objc func tapReceived() {
        let touchLocation = tapTracker.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        addToMap(pinAt: locationCoordinate)
    }
    
    @objc func removeSeekers() {
        self.round.seeker = nil
        setTeamVisible(false)
    }
    
    func addToMap(pinAt: CLLocationCoordinate2D) {
        
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = pinAt
        annotation.title = "Boundary \(boundaries.count + 1)"
        
        if boundaries.count == 0 {
            annotation.subtitle = "Tap to clear"
        }
        
        boundaries.append(annotation)
        mapView.addAnnotation(annotation)
        reloadBorder()
        
    }
    
    func reloadBorder() {
        if borderDrawing != nil {
            mapView.removeOverlay(borderDrawing)
        }
        if boundaries.count == 0 {
            return
        }
        
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for annotation in boundaries {
            points.append(annotation.coordinate)
        }
        
        if let startPoint = boundaries.first?.coordinate {
            points.append(startPoint)
        }
        
        
        borderDrawing = MKPolyline(coordinates: &points, count: points.count)
        mapView.addOverlay(borderDrawing, level: .aboveLabels)
        
        
    }
    
    
    
    
    @objc func finishEditingRound() {
        hud = alerts.startProgressHud(withMsg: "Creating Round", style: .dark)
        self.view.isUserInteractionEnabled = false
        
        self.round.boundaryPoints = []
        self.round.name = roundName.text
        
        for spot in boundaries {
            self.round.boundaryPoints.append(spot.coordinate)
        }
        
        self.game.rounds.append(self.round)
        
        FirebaseAPIClient.updateRemoteGame(game: self.game, success: {
            self.alerts.triggerCallback()
        }) {
            self.alerts.triggerCallback()
        }

    }
    
    

}
