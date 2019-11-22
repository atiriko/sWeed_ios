//
//  MapViewController.swift
//  sWeed
//
//  Created by Atahan on 29/10/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBAction func logoutbtn(_ sender: Any) {
        Account().Logout()
        System().ChangeViewFullScreen(storyboard: "Main", viewName: "SignUp", view: self)
            }

//    var dispenser = database().ReturnDispensers()
    
    @IBOutlet weak var ProfileBtn: UIButton!
    @IBAction func profileBtn(_ sender: Any) {
        Account().Logout()
        System().ChangeViewFullScreen(storyboard: "Main", viewName: "SignUp", view: self)
        
        //database().AddDispenserInfoToDispenserClass(){(Dispensers)in
          //  database().CreateStockForDipenser(dispenserId: Dispensers[0].DispenserId, name: //"Blue Dream", price: "12.5$/g")
       // }
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.bringSubviewToFront(ProfileBtn)
    }

}
