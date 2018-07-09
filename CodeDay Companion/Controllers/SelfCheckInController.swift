//
//  SelfCheckInController.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/8/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit
import SwiftDate

class SelfCheckInController : UIViewController {
    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var attendeeNameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    weak var dateTimer: Timer?
    
    deinit {
        dateTimer?.invalidate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateDateLabel() {
        let today = DateInRegion()
        self.dateLabel.text = today.toFormat("MMMM d, yyyy h:mm:ss a")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTimer?.invalidate()
        dateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateDateLabel()
        }
        
        updateDateLabel()
        
        let reg = UserStore.getUserRegistration()
        let checkIn = UserStore.getCheckInInfo()
        
        attendeeNameLabel.text = reg?.name ?? "DO NOT ADMIT!"
        
        let attrs = codeLabel.attributedText?.mutableCopy() as! NSMutableAttributedString
        attrs.addAttribute(.kern, value: 10, range: NSRange(location: 0, length: 3))
        attrs.mutableString.setString(checkIn?.code ?? "FAKE")
        codeLabel.attributedText = attrs
        
        ticketView.layer.shadowColor = UIColor.black.cgColor
        ticketView.layer.shadowOffset = CGSize(width: 0, height: 0)
        ticketView.layer.shadowRadius = 10
        ticketView.layer.shadowOpacity = 0.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animateKeyframes(withDuration: 10, delay: 0.0, options:[UIViewKeyframeAnimationOptions.repeat, UIViewKeyframeAnimationOptions.allowUserInteraction, UIViewKeyframeAnimationOptions.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/8) {
                self.backgroundView.backgroundColor = UIColor.init(named: "CodeDay Red")
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/4) {
                self.backgroundView.backgroundColor = UIColor.init(named: "CodeDay Green")
            }
            
            UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
                self.backgroundView.backgroundColor = UIColor.init(named: "CodeDay Blue")
            }
            
            UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
                self.backgroundView.backgroundColor = UIColor.init(named: "CodeDay Red")
            }
        }, completion: nil)
    }
}
