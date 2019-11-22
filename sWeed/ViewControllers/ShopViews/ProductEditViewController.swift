//
//  ProductEditViewController.swift
//  sWeed
//
//  Created by Atahan on 21/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit

class ProductEditViewController: UIViewController {
    
    var productImage: UIImage!
    var productName: String!
    var productPrice: String!
    
    @IBAction func ConfirmBtn(_ sender: Any) {
        
    }
    @IBOutlet weak var ProductImage: UIImageView!
    
    @IBOutlet weak var ProductPriceField: UITextField!
    @IBAction func CancelBtn(_ sender: Any) {
        System().ChangeViewFullScreen(storyboard: "LoggedInShop", viewName: "ProductTable", view: self)
    }
    @IBOutlet weak var ProductNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProductNameField.text = productName
        ProductPriceField.text = System().StringBeforeCharacter(String: productPrice, Character: "$")
        ProductImage.image = productImage

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
