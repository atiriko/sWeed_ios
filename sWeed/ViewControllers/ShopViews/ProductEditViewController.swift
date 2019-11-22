//
//  ProductEditViewController.swift
//  sWeed
//
//  Created by Atahan on 21/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit

class ProductEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var productImage: UIImage!
    var productName: String!
    var productPrice: String!
    var productId: String!
    var imagePicker = UIImagePickerController()
    var type = 1
    
    @IBAction func ConfirmBtn(_ sender: Any) {
        if type == 2{
            let itemId = System().RandomString(length: 8)
            database().EditStock(ItemId: itemId, Image: ProductImage.image!, Name: ProductNameField.text!, Price: "\(ProductPriceField.text!)$/g")
            self.dismiss(animated: true) {}
        }else{
        database().EditStock(ItemId: productId, Image: ProductImage.image!, Name: ProductNameField.text!, Price: "\(ProductPriceField.text!)$/g")
        self.dismiss(animated: true) {}
        }
        
    }
    @IBOutlet weak var ProductImage: UIImageView!
    
    @IBOutlet weak var ProductPriceField: UITextField!
    @IBAction func CancelBtn(_ sender: Any) {
        System().ChangeViewFullScreen(storyboard: "LoggedInShop", viewName: "ProductTable", view: self)
    }
    @IBOutlet weak var ProductNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        ProductImage.isUserInteractionEnabled = true
        ProductImage.addGestureRecognizer(singleTap)
        
        if type == 2{
            ProductNameField.placeholder = "Name"
            ProductPriceField.placeholder = "Price Of Product Per Gram"
            ProductImage.image = UIImage.init(named: "product_placeholder.png")
        }else{
        ProductNameField.text = productName
        ProductPriceField.text = System().StringBeforeCharacter(String: productPrice, Character: "$")
        ProductImage.image = productImage
        }

        // Do any additional setup after loading the view.
    }
    @objc func tapDetected(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            ProductImage.image = pickedImage
            // imageViewPic.contentMode = .scaleToFill
        }
        picker.dismiss(animated: true, completion: nil)
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
