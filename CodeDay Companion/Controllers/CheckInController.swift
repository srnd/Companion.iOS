//
//  SecondViewController.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 6/16/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit
import QRCode

// TODO: Dark status bar for this view.
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
        let alert = UIAlertController(title: "Coming soon :)", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

