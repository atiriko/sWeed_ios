//
//  Account.swift
//  
//
//  Created by Atahan on 29/10/2019.
//

import Foundation

public class Account{
    func CreateAccount(email:String, password:String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          // ...
        }
        
    }
}
