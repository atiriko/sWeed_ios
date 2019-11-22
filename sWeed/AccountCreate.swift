//
//  AccountCreate.swift
//  sWeed
//
//  Created by Atahan on 28/10/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import Foundation
import Firebase

public class Account {
    func CreateAccount(email:"", password:""){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          // ...
        }
        
    }
}
