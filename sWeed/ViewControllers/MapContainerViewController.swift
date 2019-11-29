//
//  MapContainerViewController.swift
//  sWeed
//
//  Created by Atahan on 31/10/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseDatabase
import CoreLocation

class MapContainerViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    let locationManager = CLLocationManager()
    let bicycleRange: Double = 2000
    let motorbikeRange: Double = 4000
    var dispenser = [Dispenser]()

    
    let mapView: GMSMapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 43.6532, longitude: -79.3832, zoom: 14))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CheckLocationServices()
        mapView.delegate = self
        
        //database().CreateDispenserWithInfo(name: "Tonarama", location: "lat:43.650422 long:-79.397568", stockId: System().RandomString(length: 8), passWord: "11511151")
        
        //Default location for Toronto
        ShowMap(location: CLLocationCoordinate2D.init(latitude: 43.6532 , longitude: -79.3832))
    }
    
    func ShowMap(location: CLLocationCoordinate2D){
        
        let userMarker = GMSMarker()
        
        userMarker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        userMarker.map = mapView
        
        //CheckUserType()
        
        CreateDispenserMapView(mapView: mapView)
//
        MakeMapStyled()
//
//
//
//        // if !(CheckIfDispenserInRange(firstCoordinate: CLLocation.init(latitude: location.latitude, longitude: location.longitude), secondCoordinate: CLLocation.init(latitude: marker.position.latitude, longitude: marker.position.longitude) )){
//
//
//        //}
//
        view = mapView
    }
    func MakeMapStyled(){
        do {
          // Set the map style by passing the URL of the local file.
          if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
          } else {
            NSLog("Unable to find style.json")
          }
        } catch {
          NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    func CreateDispenserMapView(mapView: GMSMapView){
        database().AddDispenserInfoToDispenserClass(){(Dispensers)in
            if(Dispensers.count != 0){
                
                for index in 1...Dispensers.count {
                    let Dispensers = Dispensers[index-1]
                    
                    let dispenser = GMSMarker()
                    
                   // dispenser.userData = Dispensers.DispenserId
                    dispenser.title = Dispensers.Name
                    dispenser.position = CLLocationCoordinate2D(latitude: Dispensers.Lat, longitude: Dispensers.Long)
                    dispenser.icon = System().ImageScale(image: UIImage(named: "dispenser.png")!, scaledToSize: CGSize(width: 120, height: 100))
                    dispenser.userData = Dispensers.DispenserId
                    dispenser.map = mapView
                    self.dispenser.append(Dispensers)
                    
                    
                    
                    //there is a solution for showing labels on top but no need to implement it yet
                    /*https://stackoverflow.com/questions/51626944/how-to-display-marker-title-for-multiple-markers-without-tapping-on-it-in-ios-sw */
                    
                    self.AddMotorbikeCircleOnMap(location: dispenser.position, mapView: mapView)
                    self.AddCycleCircleOnMap(location: dispenser.position, mapView: mapView)
                    
                    
                }
            }
        }
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        if marker.userData != nil{
        database().AddStockInfoToStockClass(DispenserID: (marker.userData as? String)!){(Stock)in
        let storyboard = UIStoryboard(name: "LoggedInUser" , bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StockView") as! StockViewController
        vc.DispenserId = marker.userData as? String
            vc.stocks = Stock
        self.present(vc,animated: true, completion: nil)
        }
        }else{
            System().HandleError(title: "Sorry there was a problem", message: "Please try again later", dismissbtn: "Okey", view: self)
        }
        
    }

    func AddCycleCircleOnMap(location: CLLocationCoordinate2D, mapView: GMSMapView){
        
        let circleCenter = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let cycleColor = UIColor(red: 0/255, green: 191/255, blue: 247/255, alpha: 0.05)
        let circ = GMSCircle(position: circleCenter, radius: bicycleRange)
        circ.fillColor = cycleColor
        circ.strokeColor = .blue
        circ.strokeWidth = 1
        circ.map = mapView
        
        
    }
    func AddMotorbikeCircleOnMap(location: CLLocationCoordinate2D, mapView: GMSMapView){
        
        let circleCenter = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let circle = GMSCircle(position: circleCenter, radius: motorbikeRange)
        circle.fillColor = UIColor(red: 250/255, green: 101/255, blue: 50/255, alpha: 0.05)
        circle.strokeColor = .red
        circle.strokeWidth = 1
        circle.map = mapView
        
        
    }
    func CheckIfDispenserInRange(firstCoordinate: CLLocation, secondCoordinate: CLLocation) -> Bool{
        
        let distanceInMeters = firstCoordinate.distance(from: secondCoordinate)
        if (distanceInMeters <= bicycleRange){
            return true
        }
        return false
    }
    func SetupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
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
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            print("Unknown error")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        guard let LocValue: CLLocationCoordinate2D = manager.location?.coordinate else{return}
        ShowMap(location: LocValue)
        
    }
    
}



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


