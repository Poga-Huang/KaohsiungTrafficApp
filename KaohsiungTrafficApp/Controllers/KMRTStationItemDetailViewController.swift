//
//  KmrtStationItemDetailViewController.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/21.
//

import UIKit
import MapKit

class KMRTStationItemDetailViewController: UIViewController {
    
    @IBOutlet weak var showExitMapView: MKMapView!
    @IBOutlet weak var infoBackView: UIView!
    @IBOutlet weak var stationNumberLabel: UILabel!
    @IBOutlet weak var stationCHNameLabel: UILabel!
    @IBOutlet weak var stationENNameLabel: UILabel!
    @IBOutlet weak var stationAddressLabel: UILabel!
    @IBOutlet weak var stationTransferLabel: UILabel!
    @IBOutlet weak var exitInfoScrollView: UIScrollView!
    @IBOutlet weak var exitInfoSegmentedControl: UISegmentedControl!
    
    //init
    var stationItemData:KmrtLocationApi.Records
    init?(coder:NSCoder,data:KmrtLocationApi.Records){
        self.stationItemData = data
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        //輕軌沒有出口資訊
        guard stationItemData.fields.exitNumber != nil ,stationItemData.fields.nearExit != nil else{
            exitInfoSegmentedControl.removeSegment(at: 1, animated: false)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: stationItemData.fields.latitude, longitude: stationItemData.fields.longitude)
            annotation.title = stationItemData.fields.stationCHName+"站"
            annotation.subtitle = stationItemData.fields.stationENName
            showExitMapView.addAnnotation(annotation)
            return
        }
    }
    
    @IBAction func changeExitInfo(_ sender: UISegmentedControl) {
        exitInfoScrollView.contentOffset.x = CGFloat(sender.selectedSegmentIndex)*view.bounds.width
    }
    
    
    func updateUI(){
        stationNumberLabel.text = stationItemData.fields.stationNumber
        stationCHNameLabel.text = stationItemData.fields.stationCHName
        stationENNameLabel.text = stationItemData.fields.stationENName
        stationAddressLabel.text = stationItemData.fields.address
        
        switch stationItemData.fields.category{
        case "紅線":
            
            infoBackView.backgroundColor = KMRTColor.red
            stationNumberLabel.textColor = KMRTColor.red
            
        case "橘線":
            
            infoBackView.backgroundColor = KMRTColor.orange
            stationNumberLabel.textColor = KMRTColor.orange

        case "輕軌":
            
            infoBackView.backgroundColor = KMRTColor.green
            stationNumberLabel.textColor = KMRTColor.green

        default:
            infoBackView.backgroundColor = .black
            stationNumberLabel.textColor = .black

        }
        
        showExitMapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: stationItemData.fields.latitude, longitude: stationItemData.fields.longitude), latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        
        for index in 0..<stationItemData.fields.exitCount{
            guard let latitude = stationItemData.fields.exitLatitude,let longitude = stationItemData.fields.exitLongitude,let exitNumber = stationItemData.fields.exitNumber else{
                
                break
            }
            let exitLatitude = latitude[index]
            let exutLongitutde = longitude[index]

            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: exitLatitude, longitude: exutLongitutde)
            annotation.title = exitNumber[index]
            showExitMapView.addAnnotation(annotation)
        }
        
        guard let stationItemTransfer = stationItemData.fields.transfer else{
            stationTransferLabel.text = "無可轉乘車站"
            return
        }
        stationTransferLabel.text = stationItemTransfer
    }

    
   
}
