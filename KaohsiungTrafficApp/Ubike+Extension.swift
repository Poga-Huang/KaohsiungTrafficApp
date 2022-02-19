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
        guard let ubikeData = ubikeApi else {return nil}
        return "最後更新時間：" + ubikeData.data.updatedAt
    }
    
    //點擊cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapView.removeOverlay(mapView.overlays[0])
        
        guard searchContent.isEmpty == true else{
            createLinePath(data: searchContent, forRowAt: indexPath)
            return 
        }
        createLinePath(data: DataSortedByDistance, forRowAt: indexPath)

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
        cell.distanceLabel.text = convertDistance(lat1: userLocation.latitude, lng1: userLocation.longitude, lat2: Double(itemData.lat)!, lng2: Double(itemData.lng)!)
        
        //百分比圓餅圖
        let percentage = CGFloat(Float(itemData.sbi)!/Float(itemData.tot)!)
        cell.drawPercentageView(percentage: percentage)
        cell.percentageView.layer.insertSublayer(cell.whiteLayer, at: 0)
        cell.percentageView.layer.insertSublayer(cell.orangeLayer, at: 0)
        cell.percentageLabel.text = "\(Int(percentage*100))%"
    }
    
    //畫出路線
    func createLinePath(data:[UbikeApi.Data.RetVal],forRowAt indexPath:IndexPath){
        let itemData = data[indexPath.row]
        let userLocation = mapView.userLocation.coordinate
        let distance = getDistance(lat1: userLocation.latitude, lng1: userLocation.longitude, lat2: Double(itemData.lat)!, lng2: Double(itemData.lng)!)
        createLinePath(mapView, sourceLocation: userLocation, destinationLocation: CLLocationCoordinate2D(latitude: Double(itemData.lat)!, longitude: Double(itemData.lng)!)) { rect in
            self.mapView.setRegion(MKCoordinateRegion(center: MKCoordinateRegion(rect).center, latitudinalMeters: distance, longitudinalMeters: distance), animated: true)
        }
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
    //繪製線條
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        rendere.strokeColor = .systemBlue
        return rendere
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
