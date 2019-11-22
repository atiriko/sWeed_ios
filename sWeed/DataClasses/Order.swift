//
//  Order.swift
//  sWeed
//
//  Created by Atahan on 16/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import Foundation

class Order{
    var dispenserId: String
    var customerId: String
    var riderId: String
    var price: Float
    var numberOfItems: Float
    var orderNumber: String
    var products: [Product]
    var status: Int
    
    
    init(DispenserId: String, CustomerId: String, RiderId: String, NumberOfItems: Float/* ProductName: String, ProductQuantity:Float, */,Price: Float, OrderNumber: String, Products: [Product], Status: Int) {
        dispenserId = DispenserId
        customerId = CustomerId
        riderId = RiderId
        numberOfItems = NumberOfItems
        products = Products
        status = Status
        
        //productName = ProductName
        //productQuantity = ProductQuantity
        //products.append(product.init(name: ProductName, numberOfItems: ProductQuantity))
        price = Price
        orderNumber = OrderNumber
    }
}
