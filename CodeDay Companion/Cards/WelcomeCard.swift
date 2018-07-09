//
//  WelcomeCard.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/8/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit

class WelcomeCard : DashboardCard {
    func tableViewCell(_ tableView: UITableView) -> UITableViewCell {
        let reg = UserStore.getUserRegistration()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCell")! as! WelcomeViewCell
        cell.welcomeLabel.text = "Hey there, \(reg?.firstName ?? "attendee")!"
        
        let daysUntil = Utils.daysUntilCodeDay()
        
        if Utils.isItCodeDay() {
            cell.daysUntilLabel.text = "It's CodeDay!"
        } else if daysUntil < 0 {
            cell.daysUntilLabel.text = "CodeDay is over :("
        } else {
            cell.daysUntilLabel.text = "There are \(daysUntil) days until CodeDay."
        }
        
        return cell
    }
}
