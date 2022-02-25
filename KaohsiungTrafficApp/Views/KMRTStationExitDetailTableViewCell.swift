//
//  KMRTStationExitDetailTableViewCell.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/24.
//

import UIKit

class KMRTStationExitDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exitNumberLabel: UILabel!
    @IBOutlet weak var nearExitTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
