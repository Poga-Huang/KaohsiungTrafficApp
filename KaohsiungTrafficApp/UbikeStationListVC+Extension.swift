//
//  UbikeStationListVC+Extension.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/14.
//

import UIKit
import MapKit
private let reusableIdentifier = "stationItemCell"

//UITableViewDataSource
extension UbikeStationListViewController:UITableViewDataSource,UITableViewDelegate{
    
    //row數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard DataSortedByDistance.isEmpty == false else {return 1}
        guard searchContent.isEmpty == true else{return searchContent.count}
        return DataSortedByDistance.count
    }
    //cell顯示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as? UbikeStationItemTableViewCell else{return UITableViewCell()}
        guard DataSortedByDistance.isEmpty == false else {return cell}
        guard searchContent.isEmpty == true else {
            configure(cell, forRowAt: indexPath, data: searchContent)
            return cell
        }
        configure(cell, forRowAt: indexPath, data: DataSortedByDistance)
        return cell
    }
    //section Header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let ubikeData = ubikeData else {return nil}
        return "最後更新時間：" + ubikeData.data.updatedAt
    }
    
    //點擊cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard searchContent.isEmpty == true else{
            let itemData = searchContent[indexPath.row]
            mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:Double(itemData.lat)!, longitude: Double(itemData.lng)!), latitudinalMeters: 500, longitudinalMeters: 500)
            return 
        }
        let itemData = DataSortedByDistance[indexPath.row]
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:Double(itemData.lat)!, longitude: Double(itemData.lng)!), latitudinalMeters: 500, longitudinalMeters: 500)
    }
    
    func configure(_ cell:UbikeStationItemTableViewCell,forRowAt indexPath:IndexPath,data:[UbikeApi.Data.RetVal]){
        guard data.isEmpty == false else {return}
        let itemData = data[indexPath.row]
        let userLocation = mapView.userLocation.coordinate
        cell.loadingActivityIndicator.stopAnimating()
        cell.sareaLabel.text = itemData.sarea
        cell.arLabel.text = itemData.ar
        cell.totLabel.text = "總車位：\(itemData.tot)個"
        cell.sbiLabel.text = "剩餘車輛：\(itemData.sbi)輛"
        cell.distanceLabel.text = "距離您" + convertDistance(lat1: userLocation.latitude, lng1: userLocation.longitude, lat2: Double(itemData.lat)!, lng2: Double(itemData.lng)!)
        //百分比圓餅圖
        let percentage = CGFloat(Float(itemData.sbi)!/Float(itemData.tot)!)
        cell.drawPercentageView(percentage: percentage)
        cell.percentageLabel.text = "\(Int(percentage*100))%"
    }
}
//MKMapViewDelegate,CLLocationManagerDelegate
extension UbikeStationListViewController:MKMapViewDelegate,CLLocationManagerDelegate{
    //加入使用者位置
    func addUseUserLocation(){
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    //把所有的點加入到地圖
    func addUbikeStation(){
        guard DataSortedByDistance.isEmpty == false else{return}
        var annotations = [MKPointAnnotation]()
        for index in 0..<DataSortedByDistance.count{
            let stationData = DataSortedByDistance[index]
            let station = MKPointAnnotation()
            station.coordinate = CLLocationCoordinate2D(latitude: Double(stationData.lat)!, longitude: Double(stationData.lng)!)
            station.title = stationData.sna
            annotations.append(station)
            mapView.addAnnotations(annotations)
        }
    }
    //更新使用者座標
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), latitudinalMeters: 500, longitudinalMeters:500)
        
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
        return distanceString + walkingTimeString
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
}

internal let locations = ["高雄全區","楠梓區","左營區","鼓山區","鹽埕區","三民區","前金區","新興區","苓雅區","前鎮區","小港區","旗津區","鳳山區","鳥松區","仁武區","大社區","大樹區","大寮區","林園區","岡山區","橋頭區","路竹區","燕巢區","阿蓮區","田寮區","梓官區","彌陀區","永安區","湖内區","茄萣區","旗山區","美濃區","內門區","杉林區","甲仙區","六龜區","那瑪夏區","桃源區","茂林區"]
extension UbikeStationListViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row]
    }
}
