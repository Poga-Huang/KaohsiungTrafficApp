//
//  KMRTListViewController.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/15.
//

import UIKit
import MapKit

class KMRTListViewController: UIViewController {

    //Map
    @IBOutlet weak var kmrtStationMapView: MKMapView!
    //TableView
    @IBOutlet weak var itemListTableView: UITableView!
    //NearStationView
    @IBOutlet weak var nearStationNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    //pickerView
    @IBOutlet weak var destinationPickerView: UIPickerView!
    @IBOutlet weak var pickerBackView: UIView!
    
    var sequence = [Int:Double]()
    var kmrtLocationApi:KmrtLocationApi?
    var selectedStationInfo:KmrtLocationApi.Records.Fields?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUseUserLocation()
        fetchMRTData()
    
    }
    //傳遞資料
    @IBSegueAction func passKmrtLocationData(_ coder: NSCoder) -> KMRTSearchStationTableViewController? {
        guard let kmrtLocationApi = kmrtLocationApi else {return nil}
        return KMRTSearchStationTableViewController(coder: coder, kmrtLocationApi: kmrtLocationApi)
    }
    
    
    //搜尋
    @IBAction func searchDestination(_ sender: UIBarButtonItem) {
        pickerBackView.isHidden = false
    }
    //顯示導航
    @IBAction func showRouteOnMap(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "提醒", message: "確定要跳出地圖顯示導航嗎?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: { _ in
            guard let targetStationInfo = self.selectedStationInfo else{return}
            //終點座標
            let targetCoordinate = CLLocationCoordinate2D(latitude: targetStationInfo.latitude, longitude: targetStationInfo.longitude)
            let targetPlacemark = MKPlacemark(coordinate: targetCoordinate)
            let targetItem = MKMapItem(placemark: targetPlacemark)
            targetItem.name = targetStationInfo.stationCHName+"站"
            //使用者目前所在位置
            let userMapItem = MKMapItem.forCurrentLocation()
            //路線兩點加入
            let routes = [userMapItem,targetItem]
            MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
            
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //取消
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        pickerBackView.isHidden = true
    }
    //選擇定點
    @IBAction func done(_ sender: UIBarButtonItem) {
        //移除上一條路線
        kmrtStationMapView.removeOverlay(kmrtStationMapView.overlays[0])
        //更新為選擇的站點
        guard let kmrtData = kmrtLocationApi else {return}
        let selectedRow = destinationPickerView.selectedRow(inComponent: 0)
        let destinationData = kmrtData.records[selectedRow].fields
        selectedStationInfo = destinationData
        updateUI(data: destinationData)
        pickerBackView.isHidden = true
    }
    //下載資料
    func fetchMRTData(){
        KmrtKlrtFetcher.shared.fetchKMRTLocationData { result in
            switch result{
            case .success(let kmrtResponse):
                DispatchQueue.main.async {
                    self.kmrtLocationApi = kmrtResponse
                    //加入站點
                    self.addMrtLrtStaiton()
                    //顯示最近的站點
                    self.showNearStationInfo()
                    //PickerView Reload
                    self.destinationPickerView.reloadComponent(0)
                    //TableView Selection
                    self.itemListTableView.allowsSelection = true
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.displayError {
                        self.fetchMRTData()
                    }
                }
            }
        }
    }

}
