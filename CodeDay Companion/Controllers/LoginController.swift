//
//  LoginController.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 6/16/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit
import BarcodeScanner
import Disk

class LoginController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPress(_ sender: UIButton) {
        loginButton.isEnabled = false
        completeLoginWithEmail(email: emailField.text?.trim())
    }
    
    @IBAction func returnKeyPressed(_ sender: UITextField) {
        loginButton.isEnabled = false
        completeLoginWithEmail(email: emailField.text?.trim())
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        controller.dismiss(animated: true) { self.completeLoginWithId(ticketId: code) }
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func completeLoginWithEmail(email: String?) {
        if email == nil || email != nil && email == "" {
            let alert = UIAlertController(title: "Enter your email.", message: "We need your email to find your CodeDay ticket.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.loginButton.isEnabled = true
            self.present(alert, animated: true, completion: nil)
        } else {
            let loadingAlert = Utils.loadingAlert("Finding your ticket...")
            present(loadingAlert, animated: true, completion: nil)
            
            CompanionAPI.getRegistrationByEmail(email!) { registration, error in
                loadingAlert.dismiss(animated: false) {
                    if error == nil && registration!.ok == true {
                        if UserStore.setUserRegistration(registration!) {
                            self.performSegue(withIdentifier: "loginToMain", sender: nil)
                        } else {
                            let alert = UIAlertController(title: "Something went wrong.", message: "We weren't able to log you in. Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.loginButton.isEnabled = true
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        let alert = UIAlertController(title: "Something went wrong.", message: "We couldn't find your ticket. Please make sure you're typing the same email you used to register for CodeDay.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.loginButton.isEnabled = true
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func completeLoginWithId(ticketId: String) {
        let loadingAlert = Utils.loadingAlert("Finding your ticket...")
        present(loadingAlert, animated: true, completion: nil)

        CompanionAPI.getRegistrationById(ticketId) { registration, error in
            loadingAlert.dismiss(animated: false) {
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
            completeLoginWithId(ticketId: "cy7e74dxcyunbpp")
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
