//
//  qrCodeVC.swift
//  SignUpForm
//
//  Created by Dilip's Macbook Air on 20/11/18.
//  Copyright © 2018 dilipGurjar. All rights reserved.
//

import UIKit
import CoreImage
import QRCode
import QRCoder

class qrCodeVC: UIViewController {

    let window: UIWindow! = UIApplication.shared.keyWindow

    @IBOutlet weak var screenShotPreview: UIImageView!
    @IBOutlet weak var emailOutlet: UIButton!
    @IBOutlet weak var screenShotOutlet: UIButton!
    @IBOutlet weak var printOutlet: UIButton!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        emailOutlet.isHidden = true
        screenShotOutlet.isHidden = true
        printOutlet.isHidden = true
        screenShotPreview.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        designLabels()
        
        uiDesign()
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
//    print(qrCodeString)
        
    
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
    
    func uiDesign() {
        self.clickedImage.layer.cornerRadius = clickedImage.frame.width/2.0
        self.clickedImage.clipsToBounds = true
        clickedImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        clickedImage.layer.borderWidth = 1
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
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
                        //                        self.alertView(titleM: "Success", message: "You have been registered succesfully")
                        
                        if self.qrcodeImage == nil {
                            if idASString == "" {
                                return
                            }
                            
                            let generator = QRCodeGenerator()
                            DispatchQueue.main.async {
                                self.imgQRCode.image = generator.createImage(value: idASString, size: CGSize(width: 200, height: 200))
                                self.emailOutlet.isHidden = false
                                self.screenShotOutlet.isHidden = false
                                self.printOutlet.isHidden = false
                            }
                            
                            
                            
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
        
        
          self.alertView(titleM: "Success", message: "You have been registered succesfully")
        
        let windowImage = window.capture()
        
        UIImageWriteToSavedPhotosAlbum(windowImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        

    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "cameraPickerVC") as! cameraPickerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        vc.localFname = firstName.text!
        vc.localNamme = lastName.text!
        vc.localTelphone = tel.text!
        vc.localMoboeNO = mobileNO.text!
        vc.localEmailID = emailID.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func ScreenShotButton(_ sender: UIButton) {
        
        let windowImage = window.capture()
        if sender == printOutlet {
            print("This is Print button")
             UIImageWriteToSavedPhotosAlbum(windowImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
         


        } else {
            UIImageWriteToSavedPhotosAlbum(windowImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            self.alertView(titleM: "Screen Shot", message: "The Screen Shot has been saved in Image Library")
        }
        
       
    }

    @IBAction func printButton(_ sender: UIButton) {
//        ScreenShotButton(printOutlet)
        
        let firstActivityItem = "Text you want"
        let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
        // If you want to put an image
        let image : UIImage = screenShotPreview.image!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            //                UIActivityType.print,
            //                UIActivityType.assignToContact,
            //                UIActivityTypeSaveToCameraRoll,
            //                UIActivityTypeAddToReadingList,
            //                UIActivityTypePostToFlickr,
            //                UIActivityTypePostToVimeo,
            //                UIActivityTypePostToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
        
        
       

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
extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

public extension UIWindow {
    
    func capture() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

extension qrCodeVC :  UIImagePickerControllerDelegate  {
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print("Cound't save image")
        } else {
            
            print("Saved Successfully image")
            DispatchQueue.main.async {
                self.screenShotPreview.isHidden = false
                self.screenShotPreview.image = image
            }
        }
}
}



//let printController = UIPrintInteractionController.shared
//// 2
//let printInfo = UIPrintInfo(dictionary:nil)
//printInfo.outputType = UIPrintInfoOutputType.photoGrayscale
//printInfo.jobName = "print Job"
//printController.printInfo = printInfo
//
//// 3
//let formatter = UISimpleTextPrintFormatter(text: "THis is just text")
//formatter.perPageContentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
//printController.printFormatter = formatter
//
//// 4
//printController.present(animated: true, completionHandler: nil)




//
//let pdfData = NSMutableData()
//let imgView = UIImageView.init(image: screenShotPreview.image)
//let imageRect = CGRect(x: 0, y: 0, width: screenShotPreview.image!.size.width, height: screenShotPreview.image!.size.height)
//UIGraphicsBeginPDFContextToData(pdfData, imageRect, nil)
//UIGraphicsBeginPDFPage()
//let context = UIGraphicsGetCurrentContext()
//imgView.layer.render(in: context!)
//UIGraphicsEndPDFContext()
//
////try saving in doc dir to confirm:
//let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
//let path = dir?.appendingPathComponent("file.pdf")
//
//do {
//    try pdfData.write(to: path!, options: NSData.WritingOptions.atomic)
//} catch {
//    print("error catched")
//}
