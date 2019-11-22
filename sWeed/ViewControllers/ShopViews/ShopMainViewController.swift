//
//  ShopMainViewController.swift
//  sWeed
//
//  Created by Atahan on 15/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ShopMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBAction func EditProductsBtn(_ sender: Any) {
        System().ChangeViewFullScreen(storyboard: "LoggedInShop", viewName: "ProductTable", view: self)
    }
    
    @IBOutlet weak var AllOrdersTableView: UITableView!
    @IBOutlet weak var SingleItemTableView: UITableView!
    
    @IBOutlet weak var OrderNumberText: UILabel!

    @IBAction func CompleteOrderBtn(_ sender: Any) {
      //  database().RiderTookTheOrderFromShop(OrderNumber: orders[selectedOrder].orderNumber)
        self.AllOrdersTableView.reloadData()
        self.SingleItemTableView.reloadData()


    }
    @IBAction func RiderMissingBtn(_ sender: Any) {
    }
    @IBAction func OutOfStockBtn(_ sender: Any) {
    }
    @IBOutlet weak var CustomerNameText: UILabel!
    @IBOutlet weak var RiderNameText: UILabel!
    @IBAction func CallCustomerBtn(_ sender: Any) {
    }
    @IBAction func CallRiderBtn(_ sender: Any) {
    }
    @IBAction func SettingsBtn(_ sender: Any) {
        Account().Logout()
        System().ChangeViewFullScreen(storyboard: "Main", viewName: "SignUp", view: self)
        
    }

    var orders = [Order]()
    var products = [Product]()
    var selectedOrder = 0
    var DispenserId: String!
    var ref = Database.database().reference()
    var User_Id = Auth.auth().currentUser?.uid


    override func viewDidLoad() {
        super.viewDidLoad()
       
        //GetProductNamesInOrder(Order: 0)
        

        AllOrdersTableView.delegate = self
        AllOrdersTableView.dataSource = self
        
        SingleItemTableView.delegate = self
        SingleItemTableView.dataSource = self
        
        database().AddOrderInfoToOrderClass(DispenserID: User_Id!){(Orders)in

            print(Orders)
            //self.orders.removeAll()
           // CorrectOrders.removeFirst(Orders.count - self.orders.count)
            self.orders = Orders
            print(self.orders)
            self.selectedOrder = 0
            self.SetInitialTexts()

//            self.ProductCounts.removeAll()
            self.GetNumberOfItemsPerOrder()
            self.AllOrdersTableView.reloadData()
            self.SingleItemTableView.reloadData()
            
        }
        
      
        

    }
    var ProductCounts = [Int](){
        willSet{
            GetProductNamesInOrder(Order: 0)
            self.SingleItemTableView.reloadData()

        }
    }
    var ProductNames = [String]()
    var AmauntOfItems = [Float]()
    
    
    func GetProductNamesInOrder(Order: Int){
        self.ProductNames.removeAll()
        self.AmauntOfItems.removeAll()
        
        //print(ProductCounts.count)
        if ProductCounts.count != 0{
        for index in 1...ProductCounts[Order]{
            database().AddProductInfoToProductClass(DispenserId: User_Id!, OrderNumber: orders[Order].orderNumber){(Products)in
                
               // print(Products.count)
                self.ProductNames.append(Products[index-1].name)
                self.AmauntOfItems.append(Products[index-1].numberOfItems)
                
                //print(self.AmauntOfItems)
                //print(self.ProductCounts[0])
                //print(self.ProductNames)
                self.SingleItemTableView.reloadData()

            }
            }
        
        }
       
    }
    func GetNumberOfItemsPerOrder(){
        if orders.count != 0{
        for index in 1...orders.count{
            database().AddProductInfoToProductClass(DispenserId: User_Id!, OrderNumber: orders[index-1].orderNumber){(Products)in
                var totalItemsPerOrder: Float = 0
                for pIndex in 1...Products.count{
                    totalItemsPerOrder = totalItemsPerOrder + Products[pIndex - 1].numberOfItems

                }
                self.ProductCounts.append(Products.count)
               // print(Products.count)
                self.orders[index-1].numberOfItems = totalItemsPerOrder
                //self.GetProductNamesInOrder(Order: 0)

                self.AllOrdersTableView.reloadData()
                self.SingleItemTableView.reloadData()

                
            }
        }
        }
    }
    func SetInitialTexts(){
        if orders.count != 0{
        OrderNumberText.text = orders[0].orderNumber
        database().GetCustomerName(UserId: orders[0].customerId){(Name)in
            self.CustomerNameText.text = "Customer: \(Name)"
        }
        }
        RiderNameText.text = "Rider: Waiting For Rider"
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == AllOrdersTableView{
            return orders.count
        }else if tableView == SingleItemTableView{
            if ProductCounts.count != 0{
                //GetProductNamesInOrder(Order: 0)
                return ProductCounts[selectedOrder]
            }else{
                return 0
            }
        }
        return 1
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           if tableView == AllOrdersTableView{
               let cell = tableView.dequeueReusableCell(withIdentifier: "AllOrdersCell") as! AllOrdersTableViewCell
            
           
            
            
            cell.OrderNumberText.text = orders[indexPath.item].orderNumber
//            print(orders[indexPath.item].product.count)
            cell.NumberOfItemsText.text = "\(String(Int(orders[indexPath.item].numberOfItems))) Items"
            cell.RiderNameText.text = "Waiting For Rider"
            return cell
            
           }else if tableView == SingleItemTableView{
               let cell = tableView.dequeueReusableCell(withIdentifier: "SingleOrderCell") as!
               SingleOrderTableViewCell
               
               //GetProductNamesInOrder()
           // print("khfkg \(ProductNames.count)")
           
            if ProductNames.count >= ProductCounts[selectedOrder]{
               // print(ProductNames[indexPath.item])
               cell.ItemText.text = "Item: \(ProductNames[indexPath.item])"
               cell.AmountText.text = "Number of items: \(String(AmauntOfItems[indexPath.item])) g"
            }else{
                //GetNumberOfItemsPerOrder()
             //   GetProductNamesInOrder(Order: 0)
            }
               
               return cell
           }
       
           return UITableViewCell()
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
      if tableView == AllOrdersTableView{
             return 120
         }else if tableView == SingleItemTableView{
             return 100
         }
         return 1
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == AllOrdersTableView{
            self.ProductNames.removeAll()
            self.AmauntOfItems.removeAll()
            
            OrderNumberText.text = orders[indexPath.item].orderNumber
            database().GetCustomerName(UserId: orders[indexPath.item].customerId){(Name)in
                self.CustomerNameText.text = "Customer: \(Name)"
            }
            RiderNameText.text = "Rider: Waiting For Rider"
            
            GetProductNamesInOrder(Order: indexPath.item)
            selectedOrder = indexPath.item
            SingleItemTableView.reloadData()
            
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

}
