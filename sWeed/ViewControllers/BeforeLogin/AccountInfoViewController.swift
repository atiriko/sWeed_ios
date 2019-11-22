//
//  AccountInfoViewController.swift
//  sWeed
//
//  Created by Atahan on 29/10/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit

class AccountInfoViewController: UIViewController {
    
    @IBOutlet weak var FirstNameText: UITextField!
    @IBOutlet weak var LastNameText: UITextField!
    @IBOutlet weak var AddressText: UITextField!
    @IBOutlet weak var PostcodeText: UITextField!
    @IBOutlet weak var DateOfBirth: UIDatePicker!
    
    @IBAction func ContinueBtn(_ sender: Any) {
        if(IsUserOldEnough()){
            if database().UserExist(){
            AddInfoToDatabase()
            System().ChangeViewFullScreen(storyboard: "LoggedInUser", viewName: "Map", view: self)
            }
        }else{
            Account().DeleteCurrentAccount()
            //print(Account().userid)
            System().HandleErrorWithCompletion(title: "You need to be at least 18 years old to use the app", message: "", dismissbtn: "Okey", view: self){(true)in
                self.navigationController?.popViewController(animated: true)
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func AddInfoToDatabase(){
        database().AddToCurrentUsersDatabase(child: "FirstName", value: System().Trim(Text: FirstNameText.text!))
        database().AddToCurrentUsersDatabase(child: "LastName", value: System().Trim(Text: LastNameText.text!))
        database().AddToCurrentUsersDatabase(child: "Address", value: System().Trim(Text: AddressText.text!))
        database().AddToCurrentUsersDatabase(child: "Postcode", value: System().Trim(Text: PostcodeText.text!))
        database().AddToCurrentUsersDatabase(child: "DateOfBirth", value: TurnDatePickerIntoString())
        
    }
    //Checks if user olf enough or not.
    //Returns true if user old enough.
    func IsUserOldEnough() -> Bool{
        
        // Get Current Date
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        
        // Get User Birth Day
        let UserCalendar = Calendar.current
        let components = UserCalendar.dateComponents([.day,.month,.year], from: DateOfBirth.date)
        let Userday = components.day
        let Usermonth = components.month
        let Useryear = components.year
        
        
        //Check the age
        if (year - Useryear! > 18 ){
            return true
        }else
            if(year - Useryear! == 18 ){
                if(month - Usermonth! > 0){
                    return true
                }else
                    if(month - Usermonth! == 0){
                        if(day - Userday! > 0){
                            return true
                        }else
                            if(day - Userday! == 0){
                                return true
                            }else
                                if(day - Userday! < 0){
                                    return false
                        }
                    }else
                        if (month - Usermonth! < 0){
                            return false
                }
            }else
                if(year - Useryear! < 0){
                    return false
        }
        return false
        
        
    }
    
    //Turns Value From Date Picker Into String For Database
    func TurnDatePickerIntoString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateTxt = dateFormatter.string(from: DateOfBirth.date)
        return dateTxt
    }
    
}


