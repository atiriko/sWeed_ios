//
//  SelectedProductViewController.swift
//  sWeed
//
//  Created by Atahan on 08/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit

class SelectedProductViewController: UIViewController {

    @IBOutlet weak var StrainDescription: UILabel!
   

    @IBOutlet weak var PriceText: UILabel!
    @IBAction func NumberValueChanged(_ sender: UIStepper) {
         NumberOfItems.text = "\(Int(sender.value).description) gr"
        
        priceToPay = itemPrice! * Double(Int(Int(sender.value).description)!)
        PriceText.text = "\(priceToPay ?? 0) $"
        numberOfItems = Int(Int(sender.value).description)
    }
    @IBOutlet weak var NumberOfItems: UITextField!
    @IBOutlet weak var ItemImage: UIImageView!
    @IBAction func AddToBasketBtn(_ sender: Any) {
        
        if numberOfItemsInBasket == 0{
            database().AddToBasket(name: strainName!, price: priceToPay, numberOfItems: numberOfItems, dispenserId: dispenserId, stockId: stockId, imageUrl: itemImageUrl, TotalPrice: Float(priceToPay))
            
            database().SetTotalPriceOfBasket(TotalPrice: Float(priceToPay))
            self.dismiss(animated: true)

        }else{
            database().GetTotaPriceOfBasket(){(TotalPrice)in
                database().AddToBasket(name: self.strainName!, price: self.priceToPay, numberOfItems: self.numberOfItems, dispenserId: self.dispenserId, stockId: self.stockId, imageUrl: self.itemImageUrl, TotalPrice: TotalPrice + Float(self.priceToPay))
                
                database().SetTotalPriceOfBasket(TotalPrice: TotalPrice + Float(self.priceToPay))
                self.dismiss(animated: true)

            }

        }
        
       // StockViewController().BasketReference.isHidden = false
    }
    @IBOutlet weak var StrainName: UILabel!
    
    var numberOfItems: Int!
    var strainName: String?
    var itemImage: UIImage?
    var dispenserId: String!
    var stockId: String!
    var itemPrice: Double!
    var itemImageUrl: String!
    var priceToPay: Double!
    var numberOfItemsInBasket: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if itemImage != nil{
        ItemImage.image = itemImage
        StrainName.text = strainName
        }
        
        
        database().AddBasketInfoToBasketClass(){(BasketItems)in
            
            
            self.numberOfItemsInBasket = BasketItems.count
            
        }

        // Do any additional setup after loading the view.
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
