//
//  UbikeStationListViewController.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/14.
//

import UIKit
import MapKit


class UbikeStationListViewController: UIViewController{

    var ubikeData:UbikeApi?
    var sequence = [Int:Double]()
    var DataSortedByDistance = [UbikeApi.Data.RetVal]()
    var searchContent = [UbikeApi.Data.RetVal]()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ubikeStationListTableView: UITableView!
    @IBOutlet weak var pickerBackView: UIView!
    @IBOutlet weak var locationPickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUbikeData()
        addUseUserLocation()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        mapView.region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
    }
    //返回使用者所在地
    @IBAction func backToUserLocation(_ sender: UIBarButtonItem) {
        mapView.region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
    }
    //查詢
    @IBAction func search(_ sender: UIBarButtonItem) {
        pickerBackView.isHidden = false
    }
    //完成查詢
    @IBAction func done(_ sender: UIBarButtonItem) {
        pickerBackView.isHidden = true
        searchContent.removeAll()
        ubikeStationListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        let selectedSarea = locations[locationPickerView.selectedRow(inComponent: 0)]
        for DataSorted in DataSortedByDistance {
            guard selectedSarea != "高雄全區" else{
                searchContent = DataSortedByDistance
                ubikeStationListTableView.reloadData()
                return
            }
            if DataSorted.sarea.contains(selectedSarea){
                searchContent.append(DataSorted)
            }
        }
        if searchContent.isEmpty == true{
            remindAlert(title: "提醒", message: "該地區目前無Ubike服務") { ＿ in
                self.locationPickerView.selectRow(0, inComponent: 0, animated: false)
            }
        }
        ubikeStationListTableView.reloadData()
    }
    //取消查詢
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        pickerBackView.isHidden = true
    }
    
    //抓資料
    func fetchUbikeData(){
        //清空搜尋結果
        searchContent.removeAll()
        UbikeFetcher.shared.fetchUbikeData { result in
            switch result{
            case .success(let ubikeResponse):
                DispatchQueue.main.async {
                    self.ubikeData = ubikeResponse
                    self.dataSortedByDistance()
                    self.addUbikeStation()
                    self.ubikeStationListTableView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.displayError {
                        self.fetchUbikeData()
                    }
                }
            }
        }
    }
    
    //按距離排順序
    func dataSortedByDistance(){
        //計算距離並加入Dictionary
        for (index,i) in self.ubikeData!.data.retVal.enumerated(){
            let userLocation = self.mapView.userLocation.coordinate
            let distance = self.getDistance(lat1:userLocation.latitude, lng1: userLocation.longitude, lat2:Double(i.lat)!, lng2: Double(i.lng)!)
            self.sequence[index] = distance
        }
        //排序
        let sortedSequence = self.sequence.sorted(by:{$0.value<$1.value})
        //將排序的順序加入到Array中
        for i in sortedSequence{
            self.DataSortedByDistance.append(self.ubikeData!.data.retVal[i.key])
        }
    }
    
}

