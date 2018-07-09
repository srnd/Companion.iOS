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
    var cards: [DashboardCard] = [ ]
    var reg: Registration?
    var nowPlaying: Song?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reg = UserStore.getUserRegistration()
        
        self.announcements = UserStore.getAnnouncements()
        
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets.zero
        
        reloadTableView()
        
        // Load new announcements in
        refresh()
    }
    
    private func refresh() {
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
                    self.reloadTableView()
                    // sorry
                    self.tableView.reloadData()
                }
            }
        }
        
        if Utils.isItCodeDay() {
            CompanionAPI.getNowPlaying(reg!.event.id) { response, error in
                if error == nil && response?.nowPlaying != nil {
                    self.nowPlaying = response!.nowPlaying!
                    self.reloadTableView()
                }
            }
        }
    }
    
    private func reloadTableView() {
        tableView.beginUpdates()
        
        // Empty out the cards except for our welcome one
        cards = [ WelcomeCard() ]
        
        if nowPlaying != nil {
            cards.append(SpotifyCard(nowPlaying!))
            tableView.insertRows(at: [ IndexPath(row: cards.count - 1, section: 0) ], with: UITableViewRowAnimation.fade)
        }
        
        if !Utils.isItCodeDay() && Utils.daysUntilCodeDay() > 0 {
            cards.append(AnnouncementCard(Announcement(
                body: "Are you excited for CodeDay, \(reg!.firstName)? I know I am. It's is a lot more fun with friends, so why not invite them?",
                creator: User(username: "johnpeter", name: "John Peter"),
                link: Announcement.AnnouncementLink(url: "https://codeday.org/share", text: "Share CodeDay")
            )))
            
            if announcements.count == 0 {
                cards.append(AnnouncementCard(Announcement(
                    body: "It's pretty empty around here right now, but during CodeDay you can use the app to get announcements from the organizers, see the currently playing song, take a look at the activity schedule, and (my personal favorite!) check yourself in so you can skip those long check-in lines.",
                    creator: User(username: "johnpeter", name: "John Peter"),
                    link: nil
                )))
            }
        } else if Utils.daysUntilCodeDay() < 0 {
            cards.append(AnnouncementCard(Announcement(
                body: "I hope you had fun at CodeDay! Why not give us some feedback on how we did? It'll help us improve.",
                creator: User(username: "johnpeter", name: "John Peter"),
                link: Announcement.AnnouncementLink(url: "https://codeday.vip/\(reg!.id)/feedback", text: "Share your feedback")
            )))
        }
        
        announcements.forEach { announcement in
            cards.append(AnnouncementCard(announcement))
        }
        
        tableView.endUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cards[indexPath.row].tableViewCell(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
