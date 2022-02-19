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
    //初始新的CAShaperLayer
    let orangeLayer = CAShapeLayer()
    let whiteLayer = CAShapeLayer()
    
    
    func drawPercentageView(percentage:CGFloat){
        let degree = CGFloat.pi/180
        var startDegree:CGFloat = 270
        let radius:CGFloat = 30
        let center = CGPoint(x: percentageView.bounds.width/2, y: percentageView.bounds.width/2)
        let color =  UIColor(red: 237/255, green: 186/255, blue: 63/255, alpha: 1)
        
        //繪製圓餅圖
        var endDegree = startDegree + (360*percentage)
        var percentagePath = UIBezierPath()
        percentagePath.move(to: center)
        percentagePath.addArc(withCenter: center, radius: radius, startAngle: startDegree*degree, endAngle: endDegree*degree, clockwise: true)
            
        orangeLayer.path = percentagePath.cgPath
        orangeLayer.fillColor = color.cgColor
        orangeLayer.lineWidth = 3
        orangeLayer.strokeColor = color.cgColor
            
        startDegree = endDegree
        
        endDegree = startDegree + (360*(1-percentage))
        percentagePath = UIBezierPath()
        percentagePath.move(to: center)
        percentagePath.addArc(withCenter: center, radius: radius, startAngle: startDegree*degree, endAngle: endDegree*degree, clockwise: true)
        whiteLayer.path = percentagePath.cgPath
        whiteLayer.fillColor = UIColor.white.cgColor
        whiteLayer.lineWidth = 3
        whiteLayer.strokeColor = color.cgColor
        
    }
}
