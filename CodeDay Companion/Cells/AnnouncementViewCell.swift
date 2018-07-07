//
//  AnnouncementViewCell.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/7/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit

class AnnouncementViewCell : UITableViewCell {
    @IBOutlet weak var announcementBodyLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorPictureView: UIImageView!
    @IBOutlet weak var announcementLinkButton: UIButton!
    
    var buttonUrl: String?
    
    @IBAction func buttonPress(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: buttonUrl!)!)
    }
}
