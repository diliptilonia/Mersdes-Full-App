//
//  ViewController.swift
//  SignUpForm
//
//  Created by francois buisson on 06/10/17.
//  Copyright © 2017 dilipGurjar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   
    @IBOutlet weak var imageBaseView: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var fNameTextFiled: UITextField!
    @IBOutlet weak var lNameTextFiled: UITextField!
    @IBOutlet weak var Tel: UITextField!
    @IBOutlet weak var Mobile: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)

        imageBaseView.isHidden = true
        profilePhoto.isHidden = true
        companyNameTextField.isHidden = true
        signUpButtonOutlet.layer.cornerRadius = 15
        signUpButtonOutlet.layer.borderWidth = 3
        signUpButtonOutlet.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       imageBaseView.layer.cornerRadius = 40
       imageBaseView.layer.borderColor = UIColor.lightGray.cgColor
       imageBaseView.layer.borderWidth = 0.5
        
        fNameTextFiled.layer.cornerRadius = 30
        lNameTextFiled.layer.cornerRadius = 30
        Tel.layer.cornerRadius = 30
        Mobile.layer.cornerRadius = 30
        
        self.hideKeyboardWhenTappedAround()
        
    

    }
    
    func postAction() {
        let Url = String(format: "http://13.126.65.0/api/insert.php")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["first_name" : fNameTextFiled.text, "last_name" : lNameTextFiled.text, "mobile" : Mobile.text, "telephone" : Tel.text, "email" : emailTextField.text, "company_name" : companyNameTextField.text]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print("This is reponce\(response)")
            }
           

            if let data = data {
                do {
                    let json: [String: Any] = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    print("This is \(json)")
                    var status: String = (json["status"] as! NSString) as String
                    print(status)
                    if status == "success" {
                        self.alertView(titleM: "Success", message: "You have been registered succesfully")
                    } else {
                        self.alertView(titleM: "Faild", message: "registration Faild try again")
                    }
                    
                }catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    

   
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let FName = fNameTextFiled.text
        let LName = lNameTextFiled.text
        let tel = Tel.text
        let mobile = Mobile.text
        let email = emailTextField.text
        let companyName = companyNameTextField.text
        
        // password lenght count
       // let passLenght = password1?.count
        
    
        
        guard FName != "" else {
            alertView(titleM: "First Name", message: "Please check First Name is Empty")
            return
        }
        
        guard LName != "" else {
            alertView(titleM: "Last Name", message: "Please check Last Name is Empty")
            return
        }
         var validtel = tel?.isPhoneNumber
        guard  validtel != false else {
            alertView(titleM: "Telephone Field", message: "Please check Telephone field is Empty")
            return
        }
        
        guard mobile != "" else {
            alertView(titleM: "Mobile Field", message: "Please check Mobile field is Empty")
            return
        }
        
       var validMob = mobile?.isPhoneNumber
        guard validMob != false else {
            alertView(titleM: "Invalid Mobile No", message: "Please check Mobile no isn't valid")
            return
        }
      
      
        guard email != "" else {
            alertView(titleM: "Email", message: "Please check Email field is Empty")
            return
        }
        
        guard (email?.isValidEmail())! else {
            alertView(titleM: "Invalid Email", message: "Please check Email ID isn't correct")
            return
        }
      
        
        
       
        
        postAction()

    }
    
    // Alert View which is call in signUpButtonPressed Button
    func alertView(titleM: String, message: String) {
        let alert = UIAlertController(title: titleM, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default, handler: { action in
            if titleM == "Success" {
                print("This was success")
                self.fNameTextFiled.text = ""
                self.lNameTextFiled.text = ""
                self.Tel.text = ""
                self.Mobile.text = ""
                self.emailTextField.text = ""
                self.companyNameTextField.text = ""
                
            }
        })
//        let cancle = UIAlertAction(title: "cancle", style: .cancel, handler: { (action) in
//
//        })
        
        alert.addAction(okay)
//        alert.addAction(cancle)
        self.present(alert, animated: true, completion: nil)
    }
  
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
}
