//
//  ScheduleController.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 6/16/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit

class ScheduleController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var schedule: [[Activity]] = [ ]
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let activity = schedule[indexPath.section][indexPath.row]
        if activity.url != nil {
            UIApplication.shared.open(URL(string: activity.url!)!)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return schedule[section][0].day
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule[section].count
    }
    
    // https://stackoverflow.com/a/41385380
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 70.0 }
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell")! as! ActivityViewCell
        let activity = schedule[indexPath.section][indexPath.row]
        
        cell.titleLabel.text = activity.title
        cell.timeLabel.text = activity.hour
        
        if activity.description == nil {
            cell.descriptionLabel.isHidden = true
        } else {
            cell.descriptionLabel.isHidden = false
            cell.descriptionLabel.text = activity.description
        }
        
        if activity.url == nil {
            cell.accessoryType = .none
            cell.selectionStyle = .none
        } else {
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .gray
        }
        
        switch activity.type {
        case .event:
            cell.colorIndicator.backgroundColor =  UIColor(named: "CodeDay Red")
        default:
            cell.colorIndicator.backgroundColor =  UIColor(named: "CodeDay Blue")
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSchedule), name: .syncFinished, object: nil)
        reloadSchedule()
    }
    
    @objc func reloadSchedule() {
        let reg = UserStore.getUserRegistration()
        
        schedule = reg!.event.schedule.map { $1 }
        
        // We need to figure out which one is the actual first day of the event,
        // so we compare the time values of the first activities in each day
        // and flip them if they are incorrect.
        if schedule[0][0].time > schedule[1][0].time {
            schedule = schedule.reversed()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

