//
//  HomeItemCollectionViewCell.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/10.
//

import UIKit

class HomeItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    
    static let width = floor(Double((UIScreen.main.bounds.width-80)/2))
    
    override func awakeFromNib() {
        buttonWidth.constant = Self.width
    }
}
