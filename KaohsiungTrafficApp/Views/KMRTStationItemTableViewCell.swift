//
//  StationItemTableViewCell.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/21.
//

import UIKit

class KMRTStationItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var stationNumberLabel: UILabel!
    @IBOutlet weak var stationCHName: UILabel!
    @IBOutlet weak var stationENNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stationNumberLabel.layer.cornerRadius = stationNumberLabel.bounds.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
