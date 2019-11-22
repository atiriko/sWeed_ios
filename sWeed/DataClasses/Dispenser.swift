//
//  Dispenser.swift
//  sWeed
//
//  Created by Atahan on 31/10/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import Foundation
class Dispenser {
    var Name: String
    var Lat: Double
    var Long: Double
    var Password: String
    var DispenserId: String
    
   // var dispensers = [Dispenser]()
    
    
    init(NameText: String, Lat: Double, Long: Double, PasswordText: String, DispenserIdText: String){
        Name = NameText
        self.Lat = Lat
        self.Long = Long
        Password = PasswordText
        DispenserId = DispenserIdText
        
    }
}
