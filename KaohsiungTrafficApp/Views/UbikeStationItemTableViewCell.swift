//
//  UbikeStationItemTableViewCell.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/14.
//

import UIKit

class UbikeStationItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sareaLabel: UILabel!
    @IBOutlet weak var arLabel: UILabel!
    @IBOutlet weak var totLabel: UILabel!
    @IBOutlet weak var sbiLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var percentageView: UIView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    
    func drawPercentageView(percentage:CGFloat){
        let degree = CGFloat.pi/180
        var startDegree:CGFloat = 270
        let radius:CGFloat = 30
        let center = CGPoint(x: percentageView.bounds.width/2, y: percentageView.bounds.width/2)
        var color =  UIColor(red: 237/255, green: 186/255, blue: 63/255, alpha: 1)
        let percentages = [percentage,1-percentage]
        
        //繪製圓餅圖
        for percentage in percentages{
            let endDegree = startDegree + (360*percentage)
            let percentagePath = UIBezierPath()
            percentagePath.move(to: center)
            percentagePath.addArc(withCenter: center, radius: radius, startAngle: startDegree*degree, endAngle: endDegree*degree, clockwise: true)
            
            let percentageLayer = CAShapeLayer()
            percentageLayer.path = percentagePath.cgPath
            percentageLayer.fillColor = color.cgColor
            percentageLayer.lineWidth = 3
            percentageLayer.strokeColor = UIColor(red: 237/255, green: 186/255, blue: 63/255, alpha: 1).cgColor
            
            startDegree = endDegree
            color = .white
            
            percentageView.layer.insertSublayer(percentageLayer, at: 0)
        }
    }
    
    
}
