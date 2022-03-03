//
//  ViewController+extension.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/14.
//

import UIKit
import MapKit

extension UIViewController{
    func makeCornerRadiusAndBorder(view:UIView){
        view.layer.cornerRadius = view.bounds.width/2
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.white.cgColor
    }
    
    
    //下載失敗提示
    func displayError(completion:@escaping ()->()){
        let alert = UIAlertController(title: "下載失敗", message: "無法正常下載,請檢查網路狀態", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "重新整理", style: .default, handler: { _ in
            completion()
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    //提醒
    func remindAlert(title:String,message:String,completion:@escaping(UIAlertAction)->()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: { action in
            completion(action)
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    //根據兩點經緯度計算兩點距離
    func getDistance(lat1:Double,lng1:Double,lat2:Double,lng2:Double)->Double{
            let earthRadius:Double = 6378137.0
            
            let radLat1:Double = self.radian(degree: lat1)
            let radLat2:Double = self.radian(degree: lat2)
            
            let radLng1:Double = self.radian(degree: lng1)
            let radLng2:Double = self.radian(degree: lng2)

            let a:Double = radLat1 - radLat2
            let b:Double = radLng1 - radLng2
            
            var s:Double = 2 * asin(sqrt(pow(sin(a/2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b/2), 2)))
            s = s * earthRadius
            return s
    }
    //根據角度計算弧度
    func radian(degree:Double) -> Double {
         return degree * Double.pi/180.0
    }
    //轉換公尺公里
    func convertDistance(lat1:Double,lng1:Double,lat2:Double,lng2:Double)->String{
        
        let distance = getDistance(lat1: lat1, lng1: lng1, lat2: lat2, lng2: lng2)
        let walkingTime = round(distance/60)
        var distanceString:String
        var walkingTimeString:String
        
        switch distance{
        case 0..<1000:
            distanceString = String(format: "%.1f", distance) + "公尺"
            walkingTimeString = "(約步行\(String(format: "%.0f", walkingTime))分鐘)"
        default:
            distanceString = String(format: "%.1f", distance/1000) + "公里"
            if walkingTime < 60{
                walkingTimeString = "(約步行\(String(format: "%.0f", walkingTime))分鐘)"
            }else{
                walkingTimeString = "(約步行\(Int(walkingTime/60))小時\(Int(walkingTime)%60)分鐘)"
            }
        }
        
        return "距離您" + distanceString + walkingTimeString
    }
    //建立Path
    func createLinePath(_ map:MKMapView,sourceLocation : CLLocationCoordinate2D, destinationLocation : CLLocationCoordinate2D,completion:@escaping(MKMapRect)->()) {
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
            
            
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
            
    
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .walking
            
        let direction = MKDirections(request: directionRequest)
            
        
        direction.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("ERROR FOUND : \(error.localizedDescription)")
                }
                return
        }
        let route = response.routes[0]
        map.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        
        let rect = route.polyline.boundingMapRect
        completion(rect)
        }
    }
}
