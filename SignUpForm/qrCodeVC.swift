//
//  qrCodeVC.swift
//  SignUpForm
//
//  Created by Dilip's Macbook Air on 20/11/18.
//  Copyright © 2018 dilipGurjar. All rights reserved.
//

import UIKit
import CoreImage

class qrCodeVC: UIViewController {

   
    var idFromServer = Int()
    @IBOutlet weak var clickedImage: UIImageView!
    var sendImage = UIImage()
    @IBOutlet weak var imgQRCode: UIImageView!
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var mobileNO: UILabel!
    @IBOutlet weak var emailID: UILabel!
    
    var qrcodeImage: CIImage!
    var qrCodeString = String()
    
    var fullName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        designLabels()
        
        lastName.isHidden = true
        clickedImage.image = sendImage
                let imageData: Data? = UIImageJPEGRepresentation(sendImage, 0.4)
                let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""

        
        fullName = fName + " " + lName

        firstName.text = fullName
        tel.text = tPhone
        mobileNO.text = moNO
        emailID.text = eID
        qrCodeString = ("First Name: \(firstName.text!), Last Name\(lastName.text!), Telephone: \(tel.text!), Mobile \(mobileNO.text!), Email ID:\(emailID.text!)")
    print(qrCodeString)
        
        
//        let Url = String(format: "http://13.126.65.0/api/insert.php")

        let Url = String(format: "https://www.rayqube.com/api/insert.php")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary: [String: Any] = ["insert": "1","first_name" : firstName.text!, "last_name" : lastName.text, "mobile" : mobileNO.text, "telephone" : tel.text, "email" : emailID.text, "image": imageStr]
//        print("This is parameterDictionary \(parameterDictionary)")
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
                    self.idFromServer = 5
                    var di: [String: Any] = json["data"] as? NSDictionary as! [String : Any]
                    print("this is \(di)")
                    for (key, value) in di  {
                    print("this is key \(key)")
                        self.idFromServer = value as! Int
                    
                    }
                    
                    print("ID from server \(self.idFromServer)")
                    let idASString = String(self.idFromServer)
                    if status == "success" {
                        self.alertView(titleM: "Success", message: "You have been registered succesfully")
                        
                        if self.qrcodeImage == nil {
                            if idASString == "" {
                                return
                            }
                            let data = idASString.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
                            
                            let filter = CIFilter(name: "CIQRCodeGenerator")
                            
                            filter!.setValue(data, forKey: "inputMessage")
                            filter!.setValue("Q", forKey: "inputCorrectionLevel")
                            
                            self.qrcodeImage = filter!.outputImage
                            self.imgQRCode.image = UIImage(ciImage: self.qrcodeImage)
                            
                        }
                        //                        self.alertView(titleM: "Success", message: "You have been registered succesfully")
                        
                    } else {
                        self.alertView(titleM: "Faild", message: "registration Faild try again")
                    }
                    
                }catch {
                    print(error)
                }
            }
            }.resume()
      
    }

    
    func alertView(titleM: String, message: String) {
        let alert = UIAlertController(title: titleM, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default, handler: { action in
    
        })
        
        alert.addAction(okay)
        //        alert.addAction(cancle)
        self.present(alert, animated: true, completion: nil)
    }
    
    func designLabels() {
        labelDesign(sender: firstName)
        labelDesign(sender: tel)
        labelDesign(sender: mobileNO)
        labelDesign(sender: emailID)
    }
    
    func labelDesign(sender: UILabel) {
        sender.layer.cornerRadius = 7
        sender.layer.borderWidth = 1
        sender.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }


}

extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
