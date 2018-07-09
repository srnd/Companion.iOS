//
//  AnnouncementCard.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/8/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit
import Alamofire

class AnnouncementCard : DashboardCard {
    private var announcement: Announcement
    
    init(_ announcement: Announcement) { self.announcement = announcement }
    
    func tableViewCell(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell")! as! AnnouncementViewCell
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        
        let str = NSMutableAttributedString(string: announcement.body)
        str.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, announcement.body.lengthOfBytes(using: .utf8)))
        
        cell.announcementBodyLabel.attributedText = str
        cell.authorNameLabel.text = announcement.creator.name
        
        if announcement.link == nil {
            cell.announcementLinkButton.isHidden = true
        } else {
            cell.announcementLinkButton.isHidden = false
            cell.announcementLinkButton.setTitle(announcement.link!.text, for: .normal)
            cell.buttonUrl = announcement.link!.url
        }
        
        Alamofire.request("https://s5.studentrnd.org/photo/\(announcement.creator.username)_128/1.png").responseImage { response in
            if let image = response.result.value {
                cell.authorPictureView.image = image.af_imageRoundedIntoCircle()
            }
        }
        
        return cell
    }
}
