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
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)

        if annotation is MKPointAnnotation {
            pinView.pinTintColor = .ACCENT_BLUE
            
        }
        
        return pinView
    }
    
    
    
    
    
    
    
    func addToMap(pins: [CLLocationCoordinate2D]) {
        
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
            for coordinate in sourceBoundaries {
                centerLat += coordinate.latitude
                centerLon += coordinate.longitude
            }
            
            centerLat = centerLat/Double(sourceBoundaries.count)
            centerLon = centerLon/Double(sourceBoundaries.count)
            
            
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


}
