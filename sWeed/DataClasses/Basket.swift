//
//  Basket.swift
//  sWeed
//
//  Created by Atahan on 11/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import Foundation

class Basket{
    
    var name: String
    var numberOfItems: Float
    var price: Float
    var userId: String
    var dispenserId: String
    var stockId: String
    var imageUrl: String
    var totalPrice: Float
    
    init(Name: String, NumberOfItems: Float, Price: Float, UserId: String, DispenserId: String, StockId: String, ImageUrl: String, TotalPrice: Float){
        
        name = Name
        numberOfItems = NumberOfItems
        price = Price
        userId = UserId
        dispenserId = DispenserId
        stockId = StockId
        imageUrl = ImageUrl
        totalPrice = TotalPrice
        
    }
    
}
