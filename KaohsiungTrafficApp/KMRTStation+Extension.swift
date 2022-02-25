//
//  KMRTStation+Extension.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/24.
//

import Foundation
import UIKit

private let reusableIdentifier = "exitItemCell"

extension KMRTStationItemDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationItemData.fields.exitCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as? KMRTStationExitDetailTableViewCell else{return UITableViewCell()}
        guard let exitNumber = stationItemData.fields.exitNumber else{return cell}
        guard let nearExit = stationItemData.fields.nearExit else{return cell}
        cell.exitNumberLabel.text = exitNumber[indexPath.row]
        cell.nearExitTextView.text = nearExit[indexPath.row]
        return cell
    }
    
    
}
