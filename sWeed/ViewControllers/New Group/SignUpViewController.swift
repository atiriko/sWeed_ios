//
//  SignUpViewController.swift
//  sWeed
//
//  Created by Atahan on 28/10/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController{
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var ConfirmPasswordText: UITextField!
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView!
    
    @IBAction func CreateAccountBtn(_ sender: Any) {
        HandleSignUp()
        EmailText.text = ""
        PasswordText.text = ""
        ConfirmPasswordText.text = ""
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        System().ChangeView(storyboard:"Main", viewName:"Login", view:self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(LoadingIndicator != nil){
        LoadingIndicator.isHidden = true
        }

        //CheckIfLoggedIn()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func loadView() {
        super.loadView()
        CheckIfLoggedIn()
        //Account().CreateShopAccount(email: "NovaCannabis@sWeed.com", password: "11511151"){_ in ()}
        
    }
    
    func CheckIfLoggedIn(){
        Auth.auth().addStateDidChangeListener { (Auth, user) in
            
            if user != nil{
                database().CheckUserType(){(Type)in
                    if(Type == 1){
                        //Go to customer storyboad
                        database().CheckIfUserHasInfo(){(Exist)in
                            if Exist{
                                System().ChangeViewFullScreen(storyboard: "LoggedInUser", viewName: "Map", view: self)
                            }else{
                                Account().DeleteCurrentAccount()
                            }
                        }

                    }
                    if(Type == 2){
                        //Go to shop storyboard
                        //database().AddOrderInfoToOrderClass(DispenserID: Auth.currentUser!.uid){(Orders)in

                            let storyboard = UIStoryboard(name: "LoggedInShop" , bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "Main") as! ShopMainViewController
                            //vc.orders = Orders
                            vc.DispenserId = Auth.currentUser!.uid
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc,animated: true, completion: nil)
                       // }

                    }
                    if(Type == 3){
                        //Go to rider story board
                    }
                
                }
                
            }
        }
    }
    
    func HandleSignUp(){
        if(PasswordText.text == "" || ConfirmPasswordText.text == "" || EmailText.text == ""){
            System().HandleError(title: "Make sure you fill all the spaces", message: "", dismissbtn: "Try again", view: self)
        }else{
            if(PasswordText.text == ConfirmPasswordText.text){
                LoadingIndicator.isHidden = false
                LoadingIndicator.startAnimating()
                Account().CreateCustomerAccount(email:(EmailText.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))! ,password: (PasswordText.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))!){(result) in
                    if(result != "done"){
                        System().HandleError(title: result, message: "", dismissbtn: "Try again", view: self)
                    }
                    if(result == "done"){
                        self.LoadingIndicator.isHidden = true
                        self.LoadingIndicator.stopAnimating()
                        System().ChangeView(storyboard: "Main", viewName: "info", view: self)
                        System().ChangeView(storyboard: "Main", viewName: "info", view: MapViewController())

                    }
                }
            }else{
                self.LoadingIndicator.isHidden = true
                System().HandleError(title: "Two passwords doesn't match", message: "", dismissbtn: "Try again", view: self)
            }
            
        }
    }
}
