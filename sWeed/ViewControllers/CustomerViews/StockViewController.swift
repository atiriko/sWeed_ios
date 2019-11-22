//
//  StockViewController.swift
//  sWeed
//
//  Created by Atahan on 01/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit
import FirebaseDatabase

class StockViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var DispenserId: String!
    
    var stocks = [Stock]()
    var numberOfItems: Int = 0
    let imageCache = NSCache<AnyObject, AnyObject>()


    @IBOutlet weak var BasketReference: UIButton!
    @IBAction func BasketBtn(_ sender: Any) {
        database().AddBasketInfoToBasketClass(){(BasketItems)in
        let storyboard = UIStoryboard(name: "LoggedInUser" , bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Basket") as! BasketViewController
        vc.basketItems = BasketItems
        self.present(vc,animated: true, completion: nil)
        }
        //System().ChangeView(storyboard: "LoggedInUser", viewName: "Basket", view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
   
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if stocks.count == 0{
            System().HandleErrorWithCompletion(title: "Sorry there are no items in this shop right now", message: "Please try again later", dismissbtn: "Okay", view: self){(Completion)in
                self.dismiss(animated: true) {}
            }
        }
        return stocks.count
        
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! StockListViewCell
     
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 40, left: 20, bottom: 100, right: 20)
        layout.minimumInteritemSpacing = 4.0
        layout.minimumLineSpacing = 15.0
        layout.itemSize = CGSize(width: 150, height: 150)
        collectionView.collectionViewLayout = layout
        
        
        database().GetProductImageFromDatabse(DownloadUrl: stocks[indexPath.item].ImageUrl){(Image)in
        cell.ItemImage.image = Image
        }
        if let cachedImage = imageCache.object(forKey: stocks[indexPath.item].ImageUrl as AnyObject) as? UIImage {
            cell.ItemImage.image = cachedImage
        }else{
            
            cell.ItemImage.image = UIImage(named: "product_placeholder.png")
            
           database().GetProductImageFromDatabse(DownloadUrl: self.stocks[indexPath.item].ImageUrl){(Image)in
            self.imageCache.setObject(Image, forKey: self.stocks[indexPath.item].ImageUrl as AnyObject)
                
            cell.ItemImage.image = Image
            }
        }
        
        cell.ItemName.text = self.stocks[indexPath.item].Name
        cell.ItemPrice.text = self.stocks[indexPath.item].Price
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(stocks[indexPath.item].Name)
        
        database().GetProductImageFromDatabse(DownloadUrl: stocks[indexPath.item].ImageUrl){(Image)in
            
            database().CheckIfItemExistInBasket(StockId: self.stocks[indexPath.item].Id){(Exist)in
                if Exist{
                    System().HandleError(title: "You already have this item in your basket", message: "", dismissbtn: "Okey", view: self)
                }else{
                    let storyboard = UIStoryboard(name: "LoggedInUser" , bundle: nil)
                               let vc = storyboard.instantiateViewController(withIdentifier: "SingleItem") as! SelectedProductViewController
                               vc.strainName = self.stocks[indexPath.item].Name
                               
                               let myString: String = self.stocks[indexPath.item].Price
                                      let myStringArr = myString.components(separatedBy: "$")
                                      let priceInt = myStringArr[0]
                               vc.itemPrice = Double(priceInt)
                               vc.itemImage = Image
                               vc.itemImageUrl = self.stocks[indexPath.item].ImageUrl
                               vc.dispenserId = self.stocks[indexPath.item].DispenserId
                               vc.stockId = self.stocks[indexPath.item].Id
                             //  vc.numberOfItemsInBasket = self.stocks.count
                               self.present(vc,animated: true, completion: nil)
                }
                
                    
            }
            
           
        }
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


