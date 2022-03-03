//
//  KMRTRouteSetViewController.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/3/2.
//

import UIKit

class KMRTRouteSetViewController: UIViewController {

    @IBOutlet weak var startStationView: UIView!
    @IBOutlet weak var destinationStationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeCornerRadiusAndBorder(view: startStationView)
        makeCornerRadiusAndBorder(view: destinationStationView)
        
        
        KmrtLiveBoardFetcher.shared.fetchKmrtLiveBoardData()
    }

}
