//
//  DashboardController.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 6/16/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DashboardController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var announcements: [Announcement] = [ ]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let reg = UserStore.getUserRegistration()
        
        CompanionAPI.getAnnouncementsForEvent(reg!.event.id) { announcements, error in
            if error == nil {
                var cachedAnnouncements = UserStore.getAnnouncements()
                var dirty = false
                
                announcements?.forEach { announcement in
                    if !cachedAnnouncements.contains(where: { $0.id == announcement.id }) {
                        dirty = true
                        cachedAnnouncements.append(announcement)
                    }
                }
                
                if dirty {
                    UserStore.setAnnouncements(cachedAnnouncements)
                    
                    self.announcements = cachedAnnouncements
                    self.tableView.reloadData()
                }
            }
        }
        
        self.announcements = UserStore.getAnnouncements()
        self.tableView.reloadData()
        
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell")! as! AnnouncementViewCell
        let announcement = announcements[indexPath.row]
        
        cell.announcementBodyLabel.text = announcement.body
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
