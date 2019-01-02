//
//  RoundDetailVC-map.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/29/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import iosManagers
import UIKit
import CoreLocation
import MapKit
import MapKitGoogleStyler


extension RoundDetailVC: MKMapViewDelegate, CLLocationManagerDelegate {
    func initMap(){        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        let elemBelow = UIView(frame: seekerFrame)
        
        let mapFrame = LayoutManager.between(elementAbove: roundName, elementBelow: elemBelow, width: view.frame.width, topPadding: 2 * .MARGINAL_PADDING, bottomPadding: .PADDING)
        mapView = MKMapView(frame: mapFrame)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        view.addSubview(mapView)
        
        // Initialize other subviews
        addRecenter()
        recenter()
        
        if hasPermissions {
            instructions = UILabel(frame: CGRect(x: 0, y: 0, width: mapView.frame.width, height: 30))
            instructions.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            instructions.textColor = .white
            instructions.font = .TEXT_FONT
            instructions.text = instructionsList[instructionsCount]
            instructions.textAlignment = .center
            mapView.addSubview(instructions)
            
            Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (t) in
                self.instructionsCount = (self.instructionsCount + 1) % 3
                self.instructions.text = self.instructionsList[self.instructionsCount]
            }
        }
        
        
        
    }
    
    func addRecenter() {
        
        let size: CGFloat = 1.4
        let recenterButton = UIButton(frame: CGRect(x: mapView.frame.maxX - size * 1.2 * .PADDING, y: mapView.frame.maxY - size * 1.2 * .PADDING, width: size * .PADDING, height: size * .PADDING))
        recenterButton.setImage(UIImage(named: "recenter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        recenterButton.tintColor = borderColor
        recenterButton.layer.backgroundColor = UIColor.white.cgColor
        recenterButton.layer.cornerRadius = recenterButton.frame.width/2
        let insetamt:CGFloat = 3
        recenterButton.imageEdgeInsets = UIEdgeInsets(top: insetamt, left: insetamt, bottom: insetamt, right: insetamt)
        
        recenterButton.imageView?.layer.cornerRadius = .PADDING/2
        recenterButton.imageView?.contentMode = .scaleAspectFit
        recenterButton.addTarget(self, action: #selector(recenter), for: .touchUpInside)
        view.addSubview(recenterButton)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // This is the final step. This code can be copied and pasted into your project
        // without thinking on it so much. It simply instantiates a MKTileOverlayRenderer
        // for displaying the tile overlay.
        debugPrint("called rendererfor")
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
    
    @objc func recenter() {
        
        var center = mapView.userLocation.coordinate
        
        var centerLat: Double = 0
        var centerLon: Double = 0
        if self.round.boundaryPoints.count > 2 {
            for coordinate in self.round.boundaryPoints {
                centerLat += coordinate.latitude
                centerLon += coordinate.longitude
            }
            
            centerLat = centerLat/Double(self.round.boundaryPoints.count)
            centerLon = centerLon/Double(self.round.boundaryPoints.count)
            
            debugPrint(centerLat, centerLon)
            
            
            
            center = CLLocation(latitude: CLLocationDegrees(exactly: centerLat)!, longitude: CLLocationDegrees(exactly: centerLon)!).coordinate
        }
        
        
        
        
        mapView.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .ACCENT_BLUE
            pinView!.isDraggable = true
            pinView!.canShowCallout = true
            
            if let pointAnnotation = annotation as? MKPointAnnotation {
                if boundaries.first == pointAnnotation {
                    pinView!.pinTintColor = .red
                    let refreshButton = UIButton(type: .detailDisclosure)
                    refreshButton.setImage(UIImage.nav_refresh.withRenderingMode(.alwaysTemplate), for: .normal)
                    refreshButton.tintColor = .ACCENT_BLUE
                    pinView!.rightCalloutAccessoryView = refreshButton
                    
                    
                } else {
                    let deleteButton = UIButton(type: .detailDisclosure)
                    deleteButton.setImage(UIImage.nav_trash.withRenderingMode(.alwaysTemplate), for: .normal)
                    deleteButton.tintColor = .ACCENT_RED
                    pinView!.rightCalloutAccessoryView = deleteButton
                }
            }
        }
        else {
            pinView!.annotation = annotation
            
        }

        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        reloadBorder()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        debugPrint(view)
        hasCalloutSelected = true
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        hasCalloutSelected = false
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        debugPrint(view)
        
        if let point = view.annotation as? MKPointAnnotation {
            guard let index = boundaries.index(of: point) else { return }
            
            if index == 0 {
                boundaries = []
                mapView.removeAnnotations(mapView.annotations)
                reloadBorder()
                return
            }
            
            boundaries.remove(at: index)
            reloadBorder()
            mapView.removeAnnotation(point)
            
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
            
        } else {
            displayErrorWithLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        debugPrint(locations)
    }
    func displayErrorWithLocation() {
        debugPrint("I don't have location")
    }
    func restyleMap() {
        guard let overlayFileURLString = Bundle.main.path(forResource: "overlay", ofType: "json") else {
            return
        }
        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
        debugPrint(overlayFileURL)
        // After that, you can create the tile overlay using MapKitGoogleStyler
        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
            return
        }
        
        // And finally add it to your MKMapView
        mapView.addOverlay(tileOverlay, level: .aboveLabels)
        debugPrint(mapView.overlays)
    }
    
    
}



extension MKPointAnnotation {
    static func == (lhs: MKPointAnnotation?, rhs: MKPointAnnotation) -> Bool {
        guard let lhsUnwrap = lhs else {
            return false
        }
        return lhsUnwrap == rhs
    }
}
