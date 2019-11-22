//
//  BasketViewController.swift
//  sWeed
//
//  Created by Atahan on 09/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBAction func BuyBtnClicked(_ sender: Any) {
        database().CreateOrder(DispenserId: basketItems[0].dispenserId, Price: totalPrice, Basket: basketItems)
        
        database().ClearBasket()
        System().ChangeViewFullScreen(storyboard: "LoggedInUser", viewName: "Map", view: self)
//        System().HandleError(title: "This will go into payment page", message: "I havent implemeted it yet because I need developer account for it", dismissbtn: "Okey", view: self)
    }
    @IBOutlet weak var BuyBtn: UIButton!
    @IBOutlet weak var TotalPrice: UILabel!
    
    @IBOutlet weak var DeliveryPrice: UILabel!
    @IBOutlet weak var TableView: UITableView!
    
    var basketItems = [Basket]()
    var totalPrice:Float = 0
    var deliveryPrice: Float = 4.0
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        
        DeliveryPrice.text = "Delivery Fee: \(deliveryPrice) $"
        if(basketItems.count != 0){
            totalPrice = basketItems[0].totalPrice + deliveryPrice
            TotalPrice.text = "Total Fee: \(basketItems[0].totalPrice + deliveryPrice) $"
        }
        

        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if basketItems.count == 0{
            System().HandleErrorWithCompletion(title: "Sorry there are no items in your basket right now", message: "Please try again later", dismissbtn: "Okay", view: self){(Completion)in
                self.dismiss(animated: true) {}
            }
        }
        return basketItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell") as! BasketTableViewCell
        
//        database().GetProductImageFromDatabse(DownloadUrl: self.basketItems[indexPath.item].imageUrl){(Image)in
//        cell.BasketItemImage.image = Image
//        }
        if let cachedImage = imageCache.object(forKey: basketItems[indexPath.item].imageUrl as AnyObject) as? UIImage {
                   cell.BasketItemImage.image = cachedImage
               }else{
                   
                   cell.BasketItemImage.image = UIImage(named: "product_placeholder.png")
                   
                  database().GetProductImageFromDatabse(DownloadUrl: self.basketItems[indexPath.item].imageUrl){(Image)in
                   self.imageCache.setObject(Image, forKey: self.basketItems[indexPath.item].imageUrl as AnyObject)
                       
                   cell.BasketItemImage.image = Image
                   }
               }
        
        cell.BasketItemName.text = self.basketItems[indexPath.item].name
        
        cell.BasketItemPrice.text =
        "\(String(self.basketItems[indexPath.item].price)) $"
        
        cell.BasketItemNumber.text = "\(String(self.basketItems[indexPath.item].numberOfItems)) gr"
        //cell.Price = totalPrice
      
        cell.stockId = self.basketItems[indexPath.item].stockId
        

       
        //print(self.basketItems[indexPath.item].stockId)


        cell.BasketItemStepper.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)

       
            


        
     return cell


         
        
        
        
    }
    @objc func buttonClicked(sender: UIStepper) {
        database().GetTotaPriceOfBasket(){(TotalPrice)in
            self.totalPrice = TotalPrice
            self.TotalPrice.text = "Total Fee: \(TotalPrice + self.deliveryPrice) $"

        }
        
//        for index in 1...basketItems.count{
//            totalPrice = totalPrice + cell.basketItemPrice.[index-1].price
//            TotalPrice.text = "Total Fee: \(totalPrice + 4) $"
//        }
               }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if (basketItems.count == 1){
                database().RemoveBasket()
                basketItems.remove(at: indexPath.item)
                tableView.reloadData()
            }else{
                print(totalPrice)
                print(basketItems[indexPath.item].price)
            database().ItemInTheBasketDeleted(StockId: basketItems[indexPath.item].stockId, TotalPrice: totalPrice , ItemPrice: basketItems[indexPath.item].price)
            
            totalPrice = totalPrice - basketItems[indexPath.item].price
            TotalPrice.text = "Total Fee: \(totalPrice) $"
            basketItems.remove(at: indexPath.item)
                tableView.reloadData()
            }
            // handle delete (by removing the data from your array and updating the tableview)
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
