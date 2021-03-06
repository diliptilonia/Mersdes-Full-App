//
//  cameraPickerVC.swift
//  SignUpForm
//
//  Created by Dilip's Macbook Air on 20/11/18.
//  Copyright © 2018 dilipGurjar. All rights reserved.
//

import UIKit
import AVFoundation

class cameraPickerVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
//    var imageToConvert = UIImage()
//    let imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        backButtonOutlet.isHidden = true
//        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
   
    
    @IBAction func clickImage(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.camera
        image.cameraDevice = .front
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            //After it is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
           
            let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation:.leftMirrored)

            myImageView.image = flippedImage
        }
        else
        {
            //Error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
   
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "qrCodeVC") as! qrCodeVC
        vc.sendImage = myImageView.image!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
    @IBAction func backButton(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


