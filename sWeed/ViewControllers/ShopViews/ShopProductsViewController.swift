//
//  ShopProductsViewController.swift
//  sWeed
//
//  Created by Atahan on 21/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit
import FirebaseAuth

class ShopProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var User_Id = Auth.auth().currentUser?.uid
    var stock = [Stock]()
    let imageCache = NSCache<AnyObject, AnyObject>()
   

    @IBAction func AddItemBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LoggedInShop" , bundle: nil)
                  let vc = storyboard.instantiateViewController(withIdentifier: "ProductEdit") as! ProductEditViewController
                  vc.type = 2
                  vc.modalPresentationStyle = .fullScreen
                  self.present(vc,animated: true, completion: nil)
        
    }
    
    @IBAction func BackBtn(_ sender: Any) {
        System().ChangeViewFullScreen(storyboard: "LoggedInShop", viewName: "Main", view: self)
    }
    @IBOutlet weak var StopStartWorkingSwitchText: UILabel!
    
    @IBOutlet weak var StartStopWorkingSwitch: UISwitch!
    @IBOutlet weak var TableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        
        
        database().AddStockInfoToStockClass(DispenserID: User_Id!){(Stock)in
            self.stock = Stock
            
            self.TableView.reloadData()
        }
        TableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! DispenserProductsTableViewCell
        
        cell.ItemNameText.text = stock[indexPath.item].Name
        cell.ItemPriceText.text = stock[indexPath.item].Price
        
        
       
        database().GetProductImageFromDatabse(DownloadUrl: stock[indexPath.item].ImageUrl){(Image)in
        cell.ProductImage.image = Image
        }
        if let cachedImage = imageCache.object(forKey: stock[indexPath.item].ImageUrl as AnyObject) as? UIImage {
            cell.ProductImage.image = cachedImage
        }else{
            
            cell.ProductImage.image = UIImage(named: "product_placeholder.png")
            
           database().GetProductImageFromDatabse(DownloadUrl: self.stock[indexPath.item].ImageUrl){(Image)in
            self.imageCache.setObject(Image, forKey: self.stock[indexPath.item].ImageUrl as AnyObject)
                
            cell.ProductImage.image = Image
            }
        }
        
        
        
        
        return cell
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 145
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            database().GetProductImageFromDatabse(DownloadUrl: self.stock[indexPath.item].ImageUrl){(Image)in
            let storyboard = UIStoryboard(name: "LoggedInShop" , bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProductEdit") as! ProductEditViewController
            vc.productId = self.stock[indexPath.item].Id
            vc.productImage = Image
                vc.productName = self.stock[indexPath.item].Name
                vc.productPrice = self.stock[indexPath.item].Price
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated: true, completion: nil)
            }
            
        }
        editAction.backgroundColor = .systemGreen

        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete Item") { (rowAction, indexPath) in
            database().DeleteProduct(ProductId: self.stock[indexPath.item].Id, ImageUrl: self.stock[indexPath.item].ImageUrl)
            
            database().AddStockInfoToStockClass(DispenserID: self.User_Id!){(Stock)in
                self.stock = Stock
                
                self.TableView.reloadData()
            }
            //TODO: Delete the row at indexPath here
        }
        deleteAction.backgroundColor = .red

        return [editAction,deleteAction]
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
