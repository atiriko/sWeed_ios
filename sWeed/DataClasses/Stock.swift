//
//  Stock.swift
//  sWeed
//
//  Created by Atahan on 02/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import Foundation

class Stock {
    
    var Name: String
    var Price: String
    var ImageUrl: String
    var Id: String
    var DispenserId: String
    var Availability: Bool
    
    
    
    init(NameText: String, PriceText: String, ImageUrlText: String, Id: String , DispenserId: String, AvailabilityStatus: Bool){
        Name = NameText
        Price = PriceText
        ImageUrl = ImageUrlText
        self.Id = Id
        self.DispenserId = DispenserId
        Availability = AvailabilityStatus
        
    }
    
}
