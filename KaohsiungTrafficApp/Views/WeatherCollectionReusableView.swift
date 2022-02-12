//
//  WeatherCollectionReusableView.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/11.
//

import UIKit

class WeatherCollectionReusableView: UICollectionReusableView{
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        setUpUI()
    }
    func setUpUI(){
        weatherView.layer.cornerRadius = 20
        weatherView.layer.shadowOffset = CGSize(width: 1, height: 1)
        weatherView.layer.shadowColor = UIColor.black.cgColor
        weatherView.layer.shadowOpacity = 1
    }
    
}
