//
//  Account.swift
//  sWeed
//
//  Created by Atahan on 29/10/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

public class Account{
    var handle: AuthStateDidChangeListenerHandle?
    var ref = Database.database().reference()
    let user = Auth.auth().currentUser
    var userid = ""
    var isLoggedIn = false
    
    
    func CreateCustomerAccount(email:String, password:String, completion: @escaping (String) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) {user, error in
            if error == nil && user != nil{
                // show next page
                self.userid = Auth.auth().currentUser!.uid
                self.ref.child("Users").child(self.userid).child("id").setValue(self.userid)
                self.ref.child("Users").child(self.userid).child("email").setValue(email)
                self.ref.child("Users").child(self.userid).child("pass").setValue(password)
                self.ref.child("Users").child(self.userid).child("type").setValue("Customer")
                
                completion("done")
                
            }else{
                let result = error!.localizedDescription
                completion(result)
                
                
            }
        }
    }
    func CreateRiderAccount(email:String, password:String, completion: @escaping (String) -> Void){
          Auth.auth().createUser(withEmail: email, password: password) {user, error in
              if error == nil && user != nil{
                  self.userid = Auth.auth().currentUser!.uid
                  self.ref.child("Users").child(self.userid).child("id").setValue(self.userid)
                  self.ref.child("Users").child(self.userid).child("email").setValue(email)
                  self.ref.child("Users").child(self.userid).child("pass").setValue(password)
                  self.ref.child("Users").child(self.userid).child("type").setValue("Rider")
                  
                  completion("done")
                  
              }else{
                  let result = error!.localizedDescription
                  completion(result)
                  
                  
              }
          }
      }
    func CreateShopAccount(name:String, location:String, email:String, password:String, completion: @escaping (String) -> Void){
           Auth.auth().createUser(withEmail: email, password: password) {user, error in
               if error == nil && user != nil{
                   self.userid = Auth.auth().currentUser!.uid
                   self.ref.child("Users").child(self.userid).child("id").setValue(self.userid)
                   self.ref.child("Users").child(self.userid).child("email").setValue(email)
                   self.ref.child("Users").child(self.userid).child("pass").setValue(password)
                   self.ref.child("Users").child(self.userid).child("type").setValue("Shop")
                   
                database().CreateDispenserWithInfo(name: name, location: location, passWord: password, id: self.userid)
                   completion("done")
                   
               }else{
                   let result = error!.localizedDescription
                   completion(result)
                   
                   
               }
           }
        
       }
   
    func HandleLogin(email:String, password:String, completion: @escaping (String) -> Void){
        Auth.auth().signIn(withEmail: email, password: password){(user, error) in
            if error == nil{
                print("logged in")
            }else{
                let result = error!.localizedDescription
                completion(result)
            }
            database().CheckUserType(){(Type)in
            if(Type == 1){
                //Go to customer storyboad
                        System().ChangeView(storyboard: "LoggedInUser", viewName: "Map", view: LoginViewController())

            }
            if(Type == 2){
                //Go to shop storyboard
                database().AddOrderInfoToOrderClass(DispenserID: Auth.auth().currentUser!.uid){(Orders)in
                
                    
                    let storyboard = UIStoryboard(name: "LoggedInShop" , bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Main") as! ShopMainViewController
                    vc.orders = Orders
                    vc.DispenserId = Auth.auth().currentUser!.uid
                    vc.modalPresentationStyle = .fullScreen
                    LoginViewController().present(vc,animated: true, completion: nil)
                }

            }
            if(Type == 3){
                let storyboard = UIStoryboard(name: "LoggedInRider" , bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Main") as! RiderMainViewController
                vc.modalPresentationStyle = .fullScreen
                LoginViewController().present(vc,animated: true, completion: nil)
                //Go to rider story board
            }
            

        }
        }
        
    }
    func SendResetEmail(email:String, completion: @escaping (String) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email){(error) in
            var result: String
            if error == nil{
                result = "Reset email has been sent."
                completion(result)
                
            }else{
                result = error!.localizedDescription
                completion(result)
            }
        }
    }
    
    func GetUserEmail() -> String{
        var email = ""
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                email = user.email!
            }
        }
        return String(email)
    }
    
    func DeleteCurrentAccount(){
        self.userid = Auth.auth().currentUser!.uid
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
            self.ref.child("Users").child(self.userid).removeValue();
        }
    }
    
    func Logout(){
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
        }
        
    }
    
    func CheckIfUserLoggedIn() -> Bool{
        return isLoggedIn
    }
    
    func SetIsLoggedInTrueIfLoggedIn(){
        Auth.auth().addStateDidChangeListener { (Auth, user) in
            if user != nil{
                self.isLoggedIn = true
                
            }
        }
    }
}

