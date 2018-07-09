//
//  DashboardCard.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/8/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit

/// The base class that all dashboard cards should extend.
protocol DashboardCard {
    func tableViewCell(_ tableView: UITableView) -> UITableViewCell
}
