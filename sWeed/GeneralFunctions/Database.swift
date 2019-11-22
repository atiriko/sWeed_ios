//
//  Database.swift
//  sWeed
//
//  Created by Atahan on 29/10/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase

public class database{
    var ref = Database.database().reference()
    let User_id = Auth.auth().currentUser!.uid
    
    var infoFromDispenserDatabase: String = ""
    var dispensers = [Dispenser]()
    var stocks = [Stock]()
    var basketItems = [Basket]()
    var orders = [Order]()
    var products = [Product]()
    let storageRef = Storage.storage().reference()
    
    
    func DeleteProduct(ProductId:String){
        ref.child("Dispensers").child(User_id).child("Products").child(ProductId).removeValue()
    }
     func UserExist() -> Bool{
        if Auth.auth().currentUser != nil{
            return true
        }else{
        return false
        }
    }
    func ClearBasket(){
        ref.child("Users").child(User_id).child("Basket").removeValue()
    }
    func RiderTookTheOrderFromShop(OrderNumber: String){
        ref.child("Orders").child(User_id).child(OrderNumber).child("Status").setValue(3)
    }
    func CreateOrder(DispenserId: String, Price: Float, Basket: [Basket]){
        let orderNumber = System().RandomIntAsString(length: 4)
        
        ref.child("Orders").child(DispenserId).child(orderNumber).child("OrderNumber").setValue(orderNumber)
        ref.child("Orders").child(DispenserId).child(orderNumber).child("DispenserId").setValue(DispenserId)
        ref.child("Orders").child(DispenserId).child(orderNumber).child("CustomerId").setValue(User_id)
        ref.child("Orders").child(DispenserId).child(orderNumber).child("OrderNumber").setValue(orderNumber)
        ref.child("Orders").child(DispenserId).child(orderNumber).child("Price").setValue(Price)
        
        ref.child("Orders").child(DispenserId).child(orderNumber).child("Status").setValue(1)
        
        for index in 1...Basket.count{
            ref.child("Orders").child(DispenserId).child(orderNumber).child("Products").child(Basket[index-1].stockId).child("Name").setValue(Basket[index-1].name)
            ref.child("Orders").child(DispenserId).child(orderNumber).child("Products").child(Basket[index-1].stockId).child("NumberOfItems").setValue(Basket[index-1].numberOfItems)
        }
        
        
        
        
        
        
    }
    func GetCustomerName(UserId: String, Name: @escaping (String) -> Void){
        ref.child("Users").child(UserId).observeSingleEvent(of: .value, with: { snapshot in
            var name: String!
            
            for user_child in (snapshot.children) {
                
                let user_snap = user_child as! DataSnapshot
                if user_snap.value is String{
                    if user_snap.key == "FirstName"{
                        name = user_snap.value as? String
                    }
                }
            }
            Name(name)
            
            
            
        })
    }
    func AddOrderInfoToOrderClass(DispenserID:String, Orders: @escaping(Array<Order>) -> Void) {
        
        ref.child("Orders").child(DispenserID).observe(.value, with: { snapshot in
            var dispenserId: String!
            var customerId: String!
            var riderId: String!
            var price: Float!
            var orderNumber: String!
            
            self.orders.removeAll()
            
            for order_child in (snapshot.children) {
                
                let user_snap = order_child as! DataSnapshot
                let dict = user_snap.value as! [String: Any]
                
                dispenserId = dict["DispenserId"] as? String
                customerId = dict["CustomerId"] as? String
                riderId = dict["RiderId"] as? String ?? "0"
                price = dict["Price"] as? Float
                orderNumber = dict["OrderNumber"] as? String
                
                                   
                                
                                let post = Order(DispenserId: dispenserId, CustomerId: customerId, RiderId: riderId, NumberOfItems: 0, Price: price, OrderNumber: orderNumber, Products: self.products)
                                               
                                               self.orders.append(post)
                                  // self.orders[Int(order_child)].products[pIndex - 1].name = Products[pIndex-1].name
                                  // self.orders[index - 1].products[pIndex - 1].numberOfItems = Products[pIndex-1].numberOfItems
                                   
                                  // self.ProductCounts.append(Products.count
                
            }
            print("Changed")
            if ShopMainViewController().SingleItemTableView != nil{
                ShopMainViewController().orders = self.orders
            //    Orders(ShopMainViewController().orders)
                ShopMainViewController().AllOrdersTableView.reloadData()
                ShopMainViewController().SingleItemTableView.reloadData()
            }
            Orders(self.orders)
            

            
        })
        
        
        
    }
    
    func AddProductInfoToProductClass(DispenserId:String, OrderNumber: String, Products: @escaping ([Product]) -> Void) {
        
        var productName: String!
        var productQuantity: Float!
        self.ref.child("Orders").child(DispenserId).child(OrderNumber).child("Products").observeSingleEvent(of: .value, with: { snapshot in
            
            for product_child in (snapshot.children) {
                
                let user_snap = product_child as! DataSnapshot
                let dict = user_snap.value as! [String: Any]
                productName = dict["Name"] as? String
                productQuantity = dict["NumberOfItems"] as? Float
                
                let productPost = Product(Name: productName, NumberOfItems: productQuantity)
                
                self.products.append(productPost)
                
            }
            Products(self.products)
            
            
        })
    }
    func AddBasketInfoToBasketClass(BasketItems: @escaping(Array<Basket>) -> Void){
        
        var TotalPrice: Float = 0
        
        ref.child("Users").child(self.User_id).child("Basket").observeSingleEvent(of: .value, with: { snapshot in
            
            for user_child in (snapshot.children) {
                
                let user_snap = user_child as! DataSnapshot
                if user_snap.value is Float{
                    TotalPrice = user_snap.value as! Float
                }
            }
        })
        ref.child("Users").child(User_id).child("Basket").observeSingleEvent(of: .value, with: { snapshot in
            
            var NameText: String!
            var PriceText: Double!
            var NumberOfItems: Float!
            var DispenserId: String!
            var StockId: String!
            var ImageUrl: String!
            
            for user_child in (snapshot.children) {
                
                let user_snap = user_child as! DataSnapshot
                if user_snap.value is Float{
                    
                }else{
                    
                    let dict = user_snap.value as! [String: Any]
                    
                    NameText = dict["Item"] as? String
                    PriceText = dict["Price"] as? Double
                    DispenserId = dict["DispenserId"] as? String
                    NumberOfItems = dict["NumberOfItems"] as? Float
                    StockId = dict["StockId"] as? String
                    ImageUrl = dict["ImageUrl"] as? String
                    let post = Basket(Name: NameText, NumberOfItems: NumberOfItems, Price: Float(PriceText), UserId: self.User_id, DispenserId: DispenserId, StockId: StockId, ImageUrl: ImageUrl, TotalPrice: TotalPrice)
                    self.basketItems.append(post)
                }
                
                
                
                
            }
            BasketItems(self.basketItems)
        })
        
    }
    func RemoveBasket(){
        ref.child("Users").child(User_id).child("Basket").removeValue()
    }
    func ItemInTheBasketDeleted(StockId: String, TotalPrice: Float, ItemPrice: Float){
        ref.child("Users").child(User_id).child("Basket").child("TotalPrice").setValue(TotalPrice - ItemPrice)
        ref.child("Users").child(User_id).child("Basket").child(StockId).removeValue()
    }
    func NumberOfItemsInBasketChanged(StockId: String, NumberOfItems: Float){
        ref.child("Users").child(User_id).child("Basket").child(StockId).child("NumberOfItems").setValue(NumberOfItems)
    }
    func TotalPriceOfItemInBasketChanged(StockId: String, Price: Double){
        ref.child("Users").child(User_id).child("Basket").child(StockId).child("Price").setValue(Price)
        
    }
    func SetTotalPriceOfBasket(TotalPrice: Float){
        ref.child("Users").child(User_id).child("Basket").child("TotalPrice").setValue(TotalPrice)
    }
    func GetTotaPriceOfBasket(TotalPrice: @escaping (Float) -> Void){
        
        ref.child("Users").child(User_id).child("Basket").observeSingleEvent(of: .value, with: { snapshot in
            
            for user_child in (snapshot.children) {
                
                let user_snap = user_child as! DataSnapshot
                if user_snap.value is Float{
                    TotalPrice(user_snap.value as! Float)
                }
            }
            
        })
    }
    
    func AddStockInfoToStockClass(DispenserID: String, Stocks: @escaping (Array<Stock>) -> Void){
        ref.child("Dispensers").child(DispenserID).child("Stock").observeSingleEvent(of: .value, with: { snapshot in
            var NameText: String!
            var PriceText: String!
            var ImageUrlText: String!
            var ID: String!
            var Availability: Bool!
            
            
            for user_child in (snapshot.children) {
                
                let user_snap = user_child as! DataSnapshot
                let dict = user_snap.value as! [String: Any]
                
                NameText = dict["Name"] as? String
                PriceText = dict["Price"] as? String
                ImageUrlText = dict["URL"] as? String
                ID = dict["id"] as? String
                Availability = dict["Available"] as? Bool
                
                
                let post = Stock(NameText: NameText, PriceText: PriceText, ImageUrlText: ImageUrlText, Id: ID, DispenserId: DispenserID, AvailabilityStatus: Availability)
                self.stocks.append(post)
                // }else{
                //  System().HandleError(title: "There was an error", message: "Please try again later", dismissbtn: "Okay", view: MapContainerViewController())
                // }
                
                
            }
            Stocks(self.stocks)
            
        })
        
        
    }
    func AddDispenserInfoToDispenserClass(Dispensers: @escaping (Array<Dispenser>) -> Void){
        ref.child("Dispensers").observeSingleEvent(of: .value, with: { snapshot in
            var NameText: String = ""
            var LocationText: String = ""
            var PasswordText: String = ""
            var DispenserIdText: String = ""
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: Any]
                NameText = (dict["Name"] as! String?)!
                LocationText = (dict["Location"] as! String?)!
                PasswordText = (dict["Password"] as! String?)!
                DispenserIdText = (dict["DispenserId"] as! String?)!
                
                let lat = System().StringToLatLong(String: String(LocationText)).lat
                let long = System().StringToLatLong(String: String(LocationText)).long
                
                let post = Dispenser(NameText: NameText, Lat: lat, Long: long, PasswordText: PasswordText, DispenserIdText: DispenserIdText)
                self.dispensers.append(post)
                
            }
            
            Dispensers(self.dispensers)
        })
    }
    func GetProductImageFromDatabse(DownloadUrl: String, Image: @escaping (UIImage) -> Void){
        
        let storageRef = Storage.storage().reference(forURL: DownloadUrl)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            Image(UIImage(data: data!)!)
        }
    }
    func CheckUserType(Type: @escaping (Int) -> Void){
        ref.child("Users").child(User_id).observeSingleEvent(of: .value, with: { snapshot in
            
            for user_child in (snapshot.children) {
                
                let snap = user_child as! DataSnapshot
                let value = snap.value as? String
                
                if(value == "Customer"){
                    Type(1)
                }
                if(value == "Shop"){
                    Type(2)
                }
                if(value == "Rider"){
                    Type(3)
                }
                
                
            }
            
        })
    }
    
    
    func CreateDispenserWithInfo(name:String, location:String, passWord:String, id:String){
        self.ref.child("Dispensers").child(id).child("Name").setValue(name)
        self.ref.child("Dispensers").child(id).child("Location").setValue(location)
        self.ref.child("Dispensers").child(id).child("Password").setValue(passWord)
        self.ref.child("Dispensers").child(id).child("DispenserId").setValue(User_id)
        
        
    }
    func CreateStockForDipenser(dispenserId: String, name: String, price: String){
        let itemId = System().RandomString(length: 8)
        var url:String = ""
        
        uploadMedia(dispenserId: dispenserId, itemId: itemId){(completion) in
            url = completion!
            
            let stockRef =  self.ref.child("Dispensers").child(dispenserId).child("Stock")
            stockRef.child(itemId).child("Name").setValue(name)
            stockRef.child(itemId).child("Price").setValue(price)
            stockRef.child(itemId).child("Available").setValue(true)
            stockRef.child(itemId).child("URL").setValue(url)
            stockRef.child(itemId).child("id").setValue(itemId)
        }
        
        
    }
    func uploadMedia(dispenserId: String, itemId:String, completion: @escaping (_ url: String?) -> Void) {
        
        let stockItemPhotoRef = Storage.storage().reference().child(dispenserId).child(itemId).child("image.png")
        if let uploadData = UIImage(named: "BlueDream.png")!.jpegData(compressionQuality: 0.5) {
            stockItemPhotoRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    
                    stockItemPhotoRef.downloadURL(completion: { (url, error) in
                        completion(url?.absoluteString)
                    })
                }
            }
        }
    }
    
    
    
    func AddToCurrentUsersDatabase(child: String, value: String ){
        self.ref.child("Users").child(User_id).child(child).setValue(value)
    }
    func AddToBasket(name: String, price: Double, numberOfItems: Int, dispenserId: String, stockId: String, imageUrl: String, TotalPrice: Float){
        self.ref.child("Users").child(self.User_id).child("Basket").child(stockId).child("Price").setValue(price)
        self.ref.child("Users").child(User_id).child("Basket").child(stockId).child("Item").setValue(name)
        self.ref.child("Users").child(User_id).child("Basket").child(stockId).child("NumberOfItems").setValue(numberOfItems)
        
        self.ref.child("Users").child(User_id).child("Basket").child(stockId).child("DispenserId").setValue(dispenserId)
        self.ref.child("Users").child(User_id).child("Basket").child(stockId).child("StockId").setValue(stockId)
        
        self.ref.child("Users").child(User_id).child("Basket").child(stockId).child("ImageUrl").setValue(imageUrl)
        
        self.ref.child("Users").child(User_id).child("Basket").child("TotalPrice").setValue(TotalPrice)
        
        
    }
    func CheckIfUserHasInfo(Exist: @escaping (Bool) -> Void){
        var exist = false
        
        ref.child("Users").child(User_id).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("Address"){
                exist = true
                Exist(exist)
            }else{
                exist = false
                Exist(exist)
                
            }
            
            
        })
        
        
    }
    func CheckIUserHasBasket(Exist: @escaping (Bool) -> Void){
        var exist = false
        
        ref.child("Users").child(User_id).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("Basket"){
                exist = true
                Exist(exist)
            }else{
                exist = false
                Exist(exist)
                
            }
            
            
        })
    }
    func CheckIfItemExistInBasket(StockId:String, Exist: @escaping (Bool) -> Void){
        var exist = false
        
        ref.child("Users").child(User_id).child("Basket").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(StockId){
                exist = true
                Exist(exist)
            }else{
                exist = false
                Exist(exist)
                
            }
            
            
        })
    }
    
}
