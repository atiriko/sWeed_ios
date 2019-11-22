//
//  System.swift
//  sWeed
//
//  Created by Atahan on 29/10/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import Foundation
import UIKit

public class System: UIViewController{
    
    func HideKeyboardWhenClickedElsewhere(){
        func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
    }
    
    func HandleErrorWithCompletion(title:String, message:String, dismissbtn:String, view: UIViewController, completion: @escaping (Bool) -> Void){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: dismissbtn, style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            completion(true)
        }))
        view.present(alertController, animated: true,completion: nil)
        
    }
    func HandleError(title:String, message:String, dismissbtn:String, view: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: dismissbtn, style: UIAlertAction.Style.default))
        view.present(alertController, animated: true,completion: nil)
    }
    
    func ChangeView(storyboard:String, viewName:String, view:UIViewController){
        let storyboard = UIStoryboard(name: storyboard , bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewName) as UIViewController
        view.present(vc,animated: true, completion: nil)
    }
    func StringToLatLong(String: String) -> (lat: Double, long: Double){
        let myString: String = String
        let myStringArr = myString.components(separatedBy: " ")
        let oldlat = myStringArr[0]
        let oldlong = myStringArr[1]
        let latArr = oldlat.components(separatedBy: ":")
        let longArr = oldlong.components(separatedBy: ":")
        return(Double(latArr[1])!, Double(longArr[1])!)
    }
    func Trim(Text: String) -> String{
        return Text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    func ChangeViewFullScreen(storyboard:String, viewName:String, view:UIViewController){
        let storyboard = UIStoryboard(name: storyboard , bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewName) as UIViewController
        vc.modalPresentationStyle = .fullScreen
        view.present(vc,animated: true, completion: nil)
    }
    func ImageScale(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    func RandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    func RandomIntAsString(length: Int) -> String{
        let numbers = "0123456789"
        return String((0..<length).map{ _ in numbers.randomElement()! })
    }
    func StringBeforeCharacter(String: String, Character: String) -> String{
        let myString: String = String
        let myStringArr = myString.components(separatedBy:Character)
        let string = myStringArr[0]
        
        return string
        
    }
    func StringToIntBeforeSpace(String: String) -> (Double){
        let myString: String = String
        let myStringArr = myString.components(separatedBy: " ")
        return Double(myStringArr[0])!
    }
}
