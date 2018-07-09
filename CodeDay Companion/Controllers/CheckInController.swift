//
//  CheckInController.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 6/16/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit
import QRCode

class CheckInController: UIViewController {
    @IBOutlet weak var ticketNameLabel: UILabel!
    @IBOutlet weak var ticketTypeLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var qrCodeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let reg = UserStore.getUserRegistration()
        ticketNameLabel.text = "\(reg!.firstName)'s Ticket"
        ticketTypeLabel.text = reg!.type.rawValue
        eventNameLabel.text = reg!.event.name
        
        DispatchQueue.main.async {
            let qrCode = QRCode(reg!.id)
            self.qrCodeView.image = qrCode?.image
        }
    }
    
    @IBAction func openSelfCheckIn(_ sender: UIButton) {
        if UserStore.getCheckInInfo() == nil, let reg = UserStore.getUserRegistration() {
            let loadingAlert = Utils.loadingAlert("Checking you in...")
            present(loadingAlert, animated: true, completion: nil)
            
            CompanionAPI.checkInTicketId(reg.id) { response, error in
                loadingAlert.dismiss(animated: false) {
                    if error == nil, response?.ok ?? false {
                        UserStore.setCheckInInfo(response!)
                        self.performSegue(withIdentifier: "selfCheckIn", sender: nil)
                    } else if error == nil {
                        let alert = UIAlertController(title: "Couldn't check you in.", message: "Error: " + (response?.error ?? "Unknown error, try again."), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Couldn't check you in.", message: "Something really bad and unexpected happened. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            self.performSegue(withIdentifier: "selfCheckIn", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

