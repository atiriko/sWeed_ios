//
//  RiderAcceptOrderViewController.swift
//  sWeed
//
//  Created by Atahan on 29/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit
import MapKit

class RiderAcceptOrderViewController: UIViewController, SlideButtonDelegate,  CLLocationManagerDelegate, MKMapViewDelegate {
    func buttonStatus(status: String, sender: MMSlidingButton) {
        print("amcik \(status)")
    }
    

    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var OrderNumberText: UILabel!
    @IBOutlet weak var AcceptBtn: MMSlidingButton!
    
    let locationManager = CLLocationManager()
    let areaSeenInMap: Double = 1000
    var directionsArray: [MKDirections] = []
    let annotation = MKPointAnnotation()
    var DispenserId: String!
    var OrderNumber: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CheckLocationServices()
        //CreateIconForDispenser()
        
                self.AcceptBtn.delegate = self

        // Do any additional setup after loading the view.
    }

    func ShowDirectionsFromDispenserToCustomer(){
        guard let location = locationManager.location?.coordinate else{
            System().HandleError(title: "There was a problem with location services", message: "Please check your location", dismissbtn: "Okay", view: self)

            // There was an error
            return
        }
        
        database().GetDispenserLocation(DispenserId: DispenserId){(DispenserLocation)in
            database().GetCustomerLocation(DispenserId: self.DispenserId, orderNumber: self.OrderNumber){(CustomerLocation)in
                
                let DispenserCoordinates = System().StringTo2dCoordinate(String: DispenserLocation)
                let CustomerCoordinates = System().StringTo2dCoordinate(String: CustomerLocation)
                
                print(DispenserCoordinates)
                print(CustomerCoordinates)
                
                self.CreateIconAtLocation(Location: DispenserCoordinates)
               // self.CreateIconAtLocation(Location: CustomerCoordinates)

                
                let request = self.CreateDirectionRequest(from: DispenserCoordinates, to: CustomerCoordinates)
                let directions = MKDirections(request: request)
               // self.ResetMapView(withNew: directions)
                
                directions.calculate{ [unowned self] (response, error) in
                    
                    guard let response = response else {return}
                    
                    for route in response.routes{
                        self.MapView.addOverlay(route.polyline)
                        self.MapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                        
                    }
                }
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
        
        return request

    }
    func CreateIconForDispenser(){
        annotation.coordinate = CLLocationCoordinate2D(latitude: 43.653097, longitude: -79.399890)
    
        MapView.addAnnotation(annotation)
    }
    func CreateIconAtLocation(Location: CLLocationCoordinate2D){
        annotation.coordinate = Location
    
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
            ShowDirectionsFromDispenserToCustomer()
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
            ShowDirectionsFromDispenserToCustomer()
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
    func LocationAsString(Location: CLLocationCoordinate2D) -> String{
        return "lat:\(Location.latitude) long:\(Location.longitude)"
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
