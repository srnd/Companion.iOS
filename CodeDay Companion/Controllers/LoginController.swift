//
//  SecondViewController.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 6/16/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit
import BarcodeScanner
import Disk

// TODO: Dark status bar for this view.
class LoginController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        controller.dismiss(animated: true) { self.completeLogin(ticketId: code) }
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func completeLogin(ticketId: String) {
        let loadingAlert = Utils.loadingAlert("Finding your ticket...")
        present(loadingAlert, animated: true, completion: nil)

        CompanionAPI.getRegistrationById(ticketId) { registration, error in
            loadingAlert.dismiss(animated: true) {
                if error == nil && registration!.ok == true {
                    if UserStore.setUserRegistration(registration!) {
                        self.performSegue(withIdentifier: "loginToMain", sender: nil)
                    } else {
                        let alert = UIAlertController(title: "Something went wrong.", message: "We weren't able to log you in. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else if error == nil && registration!.ok == false {
                    let alert = UIAlertController(title: "Something went wrong.", message: "We couldn't find your ticket; it's possible that it was cancelled. Check your email to see if this is the case.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Something went wrong.", message: "Something went wrong when getting your ticket info. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func clickLogin(_ sender: UIButton) {
        if TARGET_OS_SIMULATOR == 1 {
            completeLogin(ticketId: "cy7e74dxcyunbpp")
        } else {
            // we have a real device
            let viewController = BarcodeScannerViewController()
            viewController.codeDelegate = self
//            viewController.errorDelegate = self
            viewController.dismissalDelegate = self
            viewController.headerViewController.titleLabel.text = "Scan CodeDay ticket"
            viewController.messageViewController.textLabel.text = "Place your CodeDay ticket in the frame."
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
