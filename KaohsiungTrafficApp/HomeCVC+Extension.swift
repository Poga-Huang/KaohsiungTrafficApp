//
//  HomeCVC+Extension.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/12.
//

import UIKit

extension HomeCollectionViewController{
    
    
    
    //配置Cell
    func configure(_ cell:HomeItemCollectionViewCell,forRowAt indexPath:IndexPath){
        
        cell.itemButton.configuration?.image = UIImage(named: TransportationItem.allCases[indexPath.row].rawValue)
        
        cell.itemButton.configuration?.attributedTitle = AttributedString(TransportationItem.allCases[indexPath.row].rawValue)
        
        cell.itemButton.configuration?.attributedTitle?.font = UIFont.boldSystemFont(ofSize: 20)
        
        cell.itemButton.configuration?.imagePlacement = .top
        cell.itemButton.configuration?.imagePadding = 10
        
        cell.itemButton.configuration?.background.backgroundColor = setCellColor(indexPath: indexPath)
        
        cell.itemButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.itemButton.layer.shadowOpacity = 1
        cell.itemButton.layer.shadowColor = UIColor.black.cgColor
        cell.itemButton.tag = indexPath.row
    }
    
    //設定顏色
    func setCellColor(indexPath:IndexPath)->UIColor?{
        switch indexPath.row{
        case 0:
            return UIColor(red: 237/255, green: 186/255, blue: 63/255, alpha: 1)
        case 1:
            return UIColor(red: 60/255, green: 136/255, blue: 206/255, alpha: 1)
        case 2:
            return UIColor(red: 208/255, green: 44/255, blue: 124/255, alpha: 1)
        case 3:
            return UIColor(red: 147/255, green: 197/255, blue: 171/255, alpha: 1)
        default:
            return nil
        }
    }
    
    //配置reusableView
    func configureReusableView(view reusableView:WeatherCollectionReusableView ,data:WeatherApi){
        reusableView.loadingActivityIndicator.stopAnimating()
        let main = data.main
        let weatherId = data.weather[0].id
        //API資料的溫度單位是Kelvin(絕對溫度)
        reusableView.tempLabel.text = "🌡" + String(format: "%.1f", main.temp-273.15) + "°C"
        reusableView.humidityLabel.text = "💧\(main.humidity)%"
        reusableView.feelsLikeTempLabel.text = String(format: "%.1f", main.feelsLike-273.15) + "°C"
        
        //判斷id顯示不同的icon
        var imageName:String
        var description:String
        let hour = getCurrentHour()
        switch weatherId{
        case 200...299:
            imageName = "thunder"
            description = "雷"
        case 300...399:
            imageName = "drizzle"
            description = "小雨"
        case 500...599:
            imageName = "rain"
            description = "大雨"
        case 600...699:
            imageName = "snow"
            description = "雪"
        case 700...799:
            imageName = "atmosphere"
            description = "霧"
        case 800:
            description = "晴朗"
            switch hour{
            case 0...6:
                imageName = "night"
            case 7...16:
                imageName = "clear"
            case 16...18:
                imageName = "evening"
            case 19...23:
                imageName = "night"
            default:
                imageName = ""
            }
        case 801...899:
            description = "多雲"
            switch hour{
            case 0...6:
                imageName = "cloudsNight"
            case 7...18:
                imageName = "clouds"
            case 19...23:
                imageName = "cloudsNight"
            default:
                imageName = ""
            }
        default:
            imageName = ""
            description = ""
        }
        
        reusableView.weatherImageView.image = UIImage(named: imageName)
        reusableView.descriptionLabel.text = description
        
    }
    //獲得當前時間
    func getCurrentHour()->Int{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let timeString = dateFormatter.string(from: now)
        guard let hour = Int(timeString) else{return 0}
        return hour
    }
    
    
}
