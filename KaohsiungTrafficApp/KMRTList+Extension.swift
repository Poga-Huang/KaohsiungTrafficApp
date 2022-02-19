//
//  KMRT+Extension.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/19.
//

import UIKit
import MapKit

//UITableViewDataSource
private let reuseIdentifier = "itemCell"
extension KMRTListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MrtListItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? KmrtItemTableViewCell else{return UITableViewCell()}
        let itemName = MrtListItem.allCases[indexPath.row].rawValue
        let itemDescription = MrtListItemDescription.allCases[indexPath.row].rawValue
        cell.itemNameLabel.text = itemName
        cell.itemImageView.image = UIImage(named: itemName)
        cell.descriptionLabel.text = itemDescription
        return cell
    }
    
    
}
//UIPickerViewDataSource
extension KMRTListViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let kmrtData = kmrtLocationApi else{return 1}
        return kmrtData.records.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let kmrtData = kmrtLocationApi else{return "?"}
        let data = kmrtData.records[row].fields
        return data.stationNumber + data.stationCHName + "站"
    }
}

//MKMapViewDelegate,CLLocationManagerDelegate
extension KMRTListViewController:MKMapViewDelegate,CLLocationManagerDelegate{
    //加入使用者位置
    func addUseUserLocation(){
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        kmrtStationMapView.showsUserLocation = true
    }
    //加入站點
    func addMrtLrtStaiton(){
        guard let kmrtData = kmrtLocationApi else{return}
        
        for index in 0..<kmrtData.records.count{
            let itemData = kmrtData.records[index].fields
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: itemData.latitude, longitude: itemData.longitude)
            
            annotation.title = itemData.stationNumber + itemData.stationCHName + "站"
            annotation.subtitle = itemData.stationENName
            kmrtStationMapView.addAnnotation(annotation)
        }
    }
    
    //製作客製化圖標
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //檢查是否是使用者座標
        guard !(annotation is MKUserLocation) else{return nil}
        
        guard let annotationTitle = annotation.title,let title = annotationTitle else{return nil}
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "stationMark")
        
        if title.contains("美麗島"){
            annotationView.markerTintColor = .black
        }else if title.contains("R"){
            annotationView.markerTintColor = KMRTColor.red
        }else if title.contains("O"){
            annotationView.markerTintColor = KMRTColor.orange
        }else if title.contains("C"){
            annotationView.markerTintColor = KMRTColor.green
        }
        
        annotationView.glyphImage = UIImage(named: "KMRT")
        return annotationView
    }
    
    //繪製線條
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5
        renderer.strokeColor = .systemBlue
        return renderer
    }
    
    //顯示最近站點資訊
    func showNearStationInfo(){
        guard let kmrtData = kmrtLocationApi else {return}
        //抓出距離最近的資料位置
        for (index,data) in kmrtData.records.enumerated(){
            let latitude = data.fields.latitude
            let longitude = data.fields.longitude
            let userLocation = kmrtStationMapView.userLocation.coordinate
            let distance = getDistance(lat1:userLocation.latitude , lng1:userLocation.longitude , lat2: latitude, lng2: longitude)
            sequence[index] = distance
        }
        let sorted = sequence.sorted(by: {$0.value<$1.value})
        let nearStationData = kmrtData.records[sorted.first!.key].fields
        selectedStationInfo = nearStationData
        //更新畫面
        updateUI(data: nearStationData)
    }
    
    //更新畫面UI
    func updateUI(data:KmrtLocationApi.Records.Fields){
        let userLocation = kmrtStationMapView.userLocation.coordinate
        
        nearStationNameLabel.text = data.stationNumber + data.stationCHName + "站"
        
        distanceLabel.text = convertDistance(lat1:userLocation.latitude , lng1: userLocation.longitude, lat2: data.latitude, lng2: data.longitude)
        
        if data.stationCHName.contains("美麗島"){
            coverImageView.backgroundColor = .black
        }else if data.stationNumber.contains("R"){
            coverImageView.backgroundColor = KMRTColor.red
        }else if data.stationNumber.contains("O"){
            coverImageView.backgroundColor = KMRTColor.orange
        }else if data.stationNumber.contains("C"){
            coverImageView.backgroundColor = KMRTColor.green
        }
        
        //繪製出初始線條
        createLinePath(kmrtStationMapView, sourceLocation: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), destinationLocation: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude), completion:{ rect in
            //讓地圖完整顯示繪製出來的起點與終點
            let distance = self.getDistance(lat1: userLocation.latitude, lng1: userLocation.longitude, lat2: data.latitude, lng2: data.longitude)
            self.kmrtStationMapView.setRegion(MKCoordinateRegion(center: MKCoordinateRegion(rect).center, latitudinalMeters: distance, longitudinalMeters: distance), animated: true)
        })
    }
}
