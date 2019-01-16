//
//  ActiveGameVC-map.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/9/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import MapKit
import CoreLocation
import iosManagers

extension ActiveGameVC: MKMapViewDelegate, CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // This is the final step. This code can be copied and pasted into your project
        // without thinking on it so much. It simply instantiates a MKTileOverlayRenderer
        // for displaying the tile overlay.
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = borderColor
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        } else if let circle = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circle )
            renderer.fillColor = borderColor
            renderer.alpha = 0.3
            return renderer
            
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        if isBoundaryPoint(annotation: annotation) {
            let reuseId = "boundary"
            
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            if annotation is MKPointAnnotation {
                pinView.pinTintColor = .ACCENT_BLUE
            }
            
            return pinView
        } else {
            let reuseId = "team"
            let anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.annotation = annotation

            
            if let team = getTeamForPoint(annotation: annotation) {
                
                let sizeOfView: CGFloat = 40
                let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: sizeOfView, height: sizeOfView))
                shadowView.layer.shadowColor = UIColor.DARK_BLUE.cgColor
                shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
                shadowView.layer.shadowOpacity = 0.65
                shadowView.layer.shadowRadius = 1.0
                shadowView.clipsToBounds = false


                let imageView = UIImageView(frame: shadowView.bounds)
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = imageView.frame.width/2
                imageView.clipsToBounds = true
                imageView.image = team.img

                imageView.layer.borderColor = UIColor.white.cgColor
                imageView.layer.borderWidth = 0.75


                shadowView.addSubview(imageView)
                anView.addSubview(shadowView)
                anView.sendSubviewToBack(shadowView)
//
//                anView.sizeToFit()
////                anView.intrinsicContentSize = shadowView.bounds
//                anView.sizeThatFits(shadowView.bounds.size)
                anView.frame = shadowView.bounds
                anView.calloutOffset = CGPoint(x: 0, y: -sizeOfView/2)
                
                
            }
            anView.canShowCallout = true
            anView.rightCalloutAccessoryView = UIButton(type: .infoDark)
            
            

            
            return anView
            
            
        }
        
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {
            return
        }
        guard let teamID = (getTeamForPoint(annotation: annotation)?.uid) else {
            return
        }
        guard let location = self.round.teamLocations[teamID] else {
            return
        }
        
        
        let radius = location.horizontalAccuracy
        mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: radius * 3, longitudinalMeters: radius * 3), animated: true)
    
        teamLocationAccuracyCircle = MKCircle(center: annotation.coordinate, radius: radius)
        mapView.addOverlay(teamLocationAccuracyCircle!)
        
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else {
            return
        }
        if let team = getTeamForPoint(annotation: annotation) {
            teamToShow = team
            self.performSegue(withIdentifier: "active2Team", sender: self)

        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let circle = teamLocationAccuracyCircle {
            mapView.removeOverlay(circle)
        }
    }
    
    
    
//    func addToMap(team: Team, teamLocation: CLLocation) {
//        let inaccuracyCircle = MKCircle(center: teamLocation.coordinate, radius: teamLocation.horizontalAccuracy)
//        roundMap.addOverlay(inaccuracyCircle)
//
//    }
    
    
    func addToMap(pins: [CLLocationCoordinate2D]) {
        
        roundMap.removeAnnotations(boundaries)
        boundaries = []
        
        for pin in pins {
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = pin
            
            boundaries.append(annotation)
            roundMap.addAnnotation(annotation)
        }
        
        reloadBorder()
        
    }
    
    func reloadBorder() {
        if borderDrawing != nil {
            roundMap.removeOverlay(borderDrawing)
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
        roundMap.addOverlay(borderDrawing, level: .aboveLabels)
        
        
    }
    
    
    
    @objc func recenter() {
        
        
        var center = roundMap.userLocation.coordinate
        var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        var centerLat: Double = 0
        var centerLon: Double = 0
        
        //        let sourceBoundaries = self.round.boundaryPoints
        let sourceBoundaries: [CLLocationCoordinate2D] = boundaries.map { (annotation) -> CLLocationCoordinate2D in
            return annotation.coordinate
        }
        
        if sourceBoundaries.count > 2 {
            centerLat = (sourceBoundaries.map({ (coord) -> Double in return coord.latitude }).reduce(Double.infinity, { (res, nxt) -> Double in return min(res, nxt)}) + sourceBoundaries.map({ (coord) -> Double in return coord.latitude }).reduce(-Double.infinity, { (res, nxt) -> Double in return max(res, nxt)}))/2
            
            centerLon = (sourceBoundaries.map({ (coord) -> Double in return coord.longitude }).reduce(Double.infinity, { (res, nxt) -> Double in return min(res, nxt)}) + sourceBoundaries.map({ (coord) -> Double in return coord.longitude }).reduce(-Double.infinity, { (res, nxt) -> Double in return max(res, nxt)}))/2
            
            
            let degreePaddingFactor: Double = 1.4
            
            // adjust for the instructions embedded in the map
            
            let latBounds: [Double] = sourceBoundaries.map({ (coord) -> Double in return coord.latitude}).reduce([Double.infinity, -Double.infinity], { (res, next) -> [Double] in
                return [min(res[0], next), max(res[1], next)]
            })
            
            let lonBounds: [Double] = sourceBoundaries.map({ (coord) -> Double in return coord.longitude}).reduce([Double.infinity, -Double.infinity], { (res, next) -> [Double] in
                return [min(res[0], next), max(res[1], next)]
            })
            
            let latDiff = abs(latBounds[1] - latBounds[0]) * degreePaddingFactor
            let lonDiff = abs(lonBounds[1] - lonBounds[0]) * degreePaddingFactor
            
            centerLat += (latDiff * (30/Double(roundMap.frame.height)))
            
            

            center = CLLocation(latitude: CLLocationDegrees(exactly: centerLat)!, longitude: CLLocationDegrees(exactly: centerLon)!).coordinate
            span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(exactly: latDiff)!, longitudeDelta: CLLocationDegrees(exactly: lonDiff)!)
            
        }
        
        
        roundMap.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
    }
    
    func isBoundaryPoint(annotation: MKAnnotation) -> Bool {
        return self.round.boundaryPoints.contains(where: { (oldCoord) -> Bool in
            return sameCoordinate(c1: oldCoord, c2: annotation.coordinate)
        })
    }
    
    func getTeamForPoint(annotation: MKAnnotation) -> Team? {
        for (teamID, location) in self.round.teamLocations {
            if sameCoordinate(c1: location.coordinate, c2: annotation.coordinate) {
                return self.game.teams[teamID]
            }
        }
        return nil
    }
    
    func sameCoordinate(c1: CLLocationCoordinate2D, c2: CLLocationCoordinate2D) -> Bool {
        return c1.latitude == c2.latitude && c1.longitude == c2.longitude
    }


}
