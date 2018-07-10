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
    
    private var refreshControl = UIRefreshControl()
    
    var announcements: [Announcement] = [ ]
    var cards: [DashboardCard] = [ ]
    var reg: Registration?
    var nowPlaying: Song?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func logOut() {
        let alert = UIAlertController(title: "Log out?", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Log Out", style: .default) { action in
            if UserStore.clearUserData() {
                UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Couldn't log you out, sorry.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Oh okay", style: .default))
                self.present(errorAlert, animated: true, completion: nil)
            }
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        logOutButton.tintColor = UIColor.white
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = logOutButton
        
        reg = UserStore.getUserRegistration()
        
        self.announcements = UserStore.getAnnouncements()
        
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets.zero
        
        reloadTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .syncFinished, object: nil)
        
        // Load new announcements in
        refresh()
        
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refresh() {
        NotificationCenter.default.post(name: .beginSync, object: nil)
        
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
                    cachedAnnouncements = cachedAnnouncements.sorted() { a, b in
                        return a.postedAt!.toDate() > b.postedAt!.toDate()
                    }

                    UserStore.setAnnouncements(cachedAnnouncements)
                    
                    self.announcements = cachedAnnouncements
                    self.reloadTableView()
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
    
    @objc private func reloadTableView() {
        // get the latest registration info
        reg = UserStore.getUserRegistration()
        
        // Empty out the cards except for our welcome one
        cards = [ WelcomeCard() ]
        
        if nowPlaying != nil {
            cards.append(SpotifyCard(nowPlaying!))
        }
        
        if !(reg?.hasAge ?? false) || !(reg?.hasParent ?? false) {
            cards.append(AnnouncementCard(Announcement(
                body: "I noticed you haven't filled out your age and parent info yet. Please do this before the event so you don't have to at the door!",
                creator: User(username: "johnpeter", name: "John Peter"),
                link: Announcement.AnnouncementLink(url: "https://codeday.vip/\(reg!.id)/parent", text: "Fill out info")
            )))
        } else if !(reg?.hasWaiver ?? false) {
            cards.append(AnnouncementCard(Announcement(
                body: "You still need to sign your waiver! If you don't do this now, you'll need to do it at the door (and that's no fun).",
                creator: User(username: "johnpeter", name: "John Peter"),
                link: Announcement.AnnouncementLink(url: "https://codeday.vip/\(reg!.id)/waiver", text: "Sign waiver")
            )))
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
        
        self.refreshControl.endRefreshing()
        tableView.reloadData()
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
