//
//  RiderMainViewController.swift
//  sWeed
//
//  Created by Atahan on 24/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RiderMainViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    @IBOutlet weak var MapView: MKMapView!
    
    let locationManager = CLLocationManager()
    // In meters
    let areaSeenInMap: Double = 1000
    var directionsArray: [MKDirections] = []
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CheckLocationServices()
        CreateIconForDispenser()

        
    }
    func GetDirectionsFromLocationToLocation(){
        guard let location = locationManager.location?.coordinate else{
            // There was an error
            return
        }
        let destination = CLLocationCoordinate2D.init(latitude: 43.653097, longitude: -79.399890)
        
        let request = CreateDirectionRequest(from: location, to: destination)
        let directions = MKDirections(request: request)
        ResetMapView(withNew: directions)
        
        directions.calculate{ [unowned self] (response, error) in
            
            guard let response = response else {return}
            
            for route in response.routes{
                self.MapView.addOverlay(route.polyline)
                self.MapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
            }
        }
    }
    func CreateDirectionRequest(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> MKDirections.Request{
        let startingLocation = MKPlacemark(coordinate: from)
        let destination = MKPlacemark(coordinate: to)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
       // request.requestsAlternateRoutes = true
        
        return request

    }
    func CreateIconForDispenser(){
        annotation.coordinate = CLLocationCoordinate2D(latitude: 43.653097, longitude: -79.399890)
    
        MapView.addAnnotation(annotation)
    }
    func ResetMapView(withNew directions: MKDirections){
        MapView.removeOverlays(MapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
    
    
    
    func CenterViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: areaSeenInMap, longitudinalMeters: areaSeenInMap)
            MapView.setRegion(region, animated: true)
        }
    }
    func CheckLocationServices(){
           if CLLocationManager.locationServicesEnabled(){
               SetupLocationManager()
               CheckLocationAuthorization()
           }else{
               // show them how o turn on
           }
       }
    func CheckLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            MapView.showsUserLocation = true
            CenterViewOnUserLocation()
            GetDirectionsFromLocationToLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            MapView.showsUserLocation = true
            CenterViewOnUserLocation()
            GetDirectionsFromLocationToLocation()
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            print("Unknown error")
        }
    }
    func SetupLocationManager(){
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.startUpdatingLocation()
       }
       
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: areaSeenInMap, longitudinalMeters: areaSeenInMap)
        MapView.setRegion(region, animated: true)
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        CheckLocationAuthorization()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 4
        
        return renderer
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
