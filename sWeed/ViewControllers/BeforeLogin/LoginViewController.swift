//
//  LoginViewController.swift
//  sWeed
//
//  Created by Atahan on 29/10/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var EmailText: UITextField!
    @IBAction func LoginBtn(_ sender: Any) {
        HandleLogin()
      //  System().ChangeViewFullscreen(storyboard: "LoggedInUser", viewName:"Map", view: self)
    }
    @IBAction func ResetBtn(_ sender: Any) {
        HandleReset()
    }
    @IBAction func LeftPan(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUp") as UIViewController
        present(vc,animated:true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       if(LoadingIndicator != nil){
       LoadingIndicator.isHidden = true
       }
        
    }
    
    func HandleLogin(){
        if(PasswordText.text == "" || EmailText.text == ""){
            System().HandleError(title: "Make sure you fill all the spaces", message: "", dismissbtn: "Try again", view: self)
        }else{
            LoadingIndicator.isHidden = false
            LoadingIndicator.startAnimating()
            Account().HandleLogin(email: System().Trim(Text: EmailText.text!), password: System().Trim(Text: PasswordText.text!)){ (result) in
                self.LoadingIndicator.isHidden = true
                self.LoadingIndicator.stopAnimating()
                //System().ChangeViewFullScreen(storyboard: "LoggedInUser", viewName: "Map", view: self)
                System().HandleError(title: result, message: "", dismissbtn: "Okey", view: self)
            }
        }
        
        PasswordText.text = ""
        EmailText.text = ""
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func HandleReset(){
        if(EmailText.text == ""){
            System().HandleError(title: "Please enter your email adresss", message: "", dismissbtn: "Try again", view: self)
        }else{
            Account().SendResetEmail(email: EmailText.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)){(result)in
                System().HandleError(title: result, message: "", dismissbtn: "Okey", view: self)
            }
        }
        
    }
}
