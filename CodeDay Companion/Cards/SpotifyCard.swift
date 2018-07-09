//
//  SpotifyCard.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/8/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit
import Alamofire

class SpotifyCard : DashboardCard {
    var song: Song
    
    init(_ song: Song) { self.song = song }
    
    func tableViewCell(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotifyCell")! as! SpotifyViewCell
        
        cell.titleLabel.text = song.track
        cell.artistLabel.text = song.artist
        
        Alamofire.request(song.album.image).responseImage { response in
            if let image = response.result.value {
                cell.albumArtImage.image = image
            }
        }
        
        return cell
    }
}
