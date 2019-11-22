//
//  BasketTableViewCell.swift
//  sWeed
//
//  Created by Atahan on 09/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit

class BasketTableViewCell: UITableViewCell {

    @IBOutlet weak var BasketItemImage: UIImageView!
    @IBOutlet weak var BasketItemName: UILabel!
    @IBOutlet weak var BasketItemNumber: UITextField!
    @IBOutlet weak var BasketItemPrice: UILabel!
    @IBOutlet weak var BasketItemStepper: UIStepper!
    
    //This code is just stupid
    //For now im only making it work 
    @IBAction func StepperClicked(_ sender: UIStepper) {

        //BasketViewController().StepperClicked(Sender: sender)
        
        let price = System().StringToIntBeforeSpace(String: BasketItemPrice.text!) /
            System().StringToIntBeforeSpace(String: BasketItemNumber.text!)
        
        // There are some bugs with keep pressing - button but i can live with it for now
        if (Int(sender.value) > oldValue) {

            oldValue = oldValue + 1
            BasketItemNumber.text = "\(String(System().StringToIntBeforeSpace(String: BasketItemNumber.text!) + 1)) gr"
            
            BasketItemPrice.text = "\(price * System().StringToIntBeforeSpace(String: BasketItemNumber.text!)) $"
            
            Price = Price + Float(price)
            
            database().NumberOfItemsInBasketChanged(StockId: stockId!, NumberOfItems: Float(System().StringToIntBeforeSpace(String: BasketItemNumber.text!)))
            
            database().TotalPriceOfItemInBasketChanged(StockId: stockId!, Price: Double(price * System().StringToIntBeforeSpace(String: BasketItemNumber.text!)))
            
            

            database().SetTotalPriceOfBasket(TotalPrice: totalPrice + Float(price))
            
            totalPrice = totalPrice + Float(price)
            

        }
        else{

            if System().StringToIntBeforeSpace(String: BasketItemNumber.text!) == 1 {
                sender.value = 0
                return
            }
            oldValue = oldValue - 1


            BasketItemNumber.text = "\(String(System().StringToIntBeforeSpace(String: BasketItemNumber.text!) - 1)) gr"
            BasketItemPrice.text = "\(price * System().StringToIntBeforeSpace(String: BasketItemNumber.text!)) $"
            Price = Price - Float(price)
            database().NumberOfItemsInBasketChanged(StockId: stockId!, NumberOfItems: Float(System().StringToIntBeforeSpace(String: BasketItemNumber.text!)))
            
            database().TotalPriceOfItemInBasketChanged(StockId: stockId!, Price: Double(price * System().StringToIntBeforeSpace(String: BasketItemNumber.text!)))
        
            print(totalPrice - Float(price))
            database().SetTotalPriceOfBasket(TotalPrice: totalPrice - Float(price))
            
            totalPrice = totalPrice - Float(price)

            

        }
        //print(Price)

            
        

        
        
    }
    var oldValue: Int!
    var Price: Float = 0
    var totalPrice: Float!
    var index: Int!
    var stockId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        oldValue = 0
        
        BasketItemStepper.isHidden = true
        
        database().GetTotaPriceOfBasket(){(TotalPrice)in
            self.totalPrice = TotalPrice
        }

        //print(BasketItemPrice.text)
        //print(System().StringToIntBeforeSpace(String: BasketItemPrice.text!))
        

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
