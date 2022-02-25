//
//  KMRTStationSearchTableViewController.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/19.
//

import UIKit

private let segueIdentifier = "showStationDetail"

class KMRTSearchStationTableViewController: UITableViewController {
    
    
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    var redLine = [KmrtLocationApi.Records]()
    var orangeLine = [KmrtLocationApi.Records]()
    var klrt = [KmrtLocationApi.Records]()
    var stationDetailData:KmrtLocationApi.Records?
    
    var kmrtLocationApi:KmrtLocationApi
    init?(coder:NSCoder,kmrtLocationApi:KmrtLocationApi){
        self.kmrtLocationApi = kmrtLocationApi
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<kmrtLocationApi.records.count{
            guard let firstLetter = kmrtLocationApi.records[index].fields.stationNumber.first else{return}
            switch firstLetter {
            case "R":
                redLine.append(kmrtLocationApi.records[index])
            case "O":
                orangeLine.append(kmrtLocationApi.records[index])
            case "C":
                klrt.append(kmrtLocationApi.records[index])
            default:
                return
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func selectCategory(_ sender: UISegmentedControl) {
        tableView.reloadData()
        switch sender.selectedSegmentIndex{
        case 0:
            sender.selectedSegmentTintColor = KMRTColor.red
        case 1:
            sender.selectedSegmentTintColor = KMRTColor.orange
        case 2:
            sender.selectedSegmentTintColor = KMRTColor.green
        default:
            return
        }
    }
    
    
    //passData
    @IBSegueAction func passStationDetail(_ coder: NSCoder) -> KMRTStationItemDetailViewController? {
        guard let stationDetailData = stationDetailData else {return nil}
        return KMRTStationItemDetailViewController(coder: coder, data: stationDetailData)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !redLine.isEmpty && !orangeLine.isEmpty && !klrt.isEmpty else{return 0}
        switch categorySegmentedControl.selectedSegmentIndex{
        case 0:
            return redLine.count
        case 1:
            return orangeLine.count
        case 2:
            return klrt.count
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "stationItemCell", for: indexPath) as? KMRTStationItemTableViewCell else{return UITableViewCell()}
        switch categorySegmentedControl.selectedSegmentIndex{
        case 0:
            configureCell(cell, forRowAt: indexPath, data: redLine)
        case 1:
            configureCell(cell, forRowAt: indexPath, data: orangeLine)
        case 2:
            configureCell(cell, forRowAt: indexPath, data: klrt)
        default:
            return cell
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel()
        headerView.textAlignment = .center
        headerView.textColor = .white
        headerView.font = UIFont.boldSystemFont(ofSize: 25)
        
        switch categorySegmentedControl.selectedSegmentIndex{
        case 0:
            headerView.backgroundColor = KMRTColor.red
            headerView.text = "紅線"
            return headerView
        case 1:
            headerView.backgroundColor = KMRTColor.orange
            headerView.text = "橘線"
            return headerView
        case 2:
            headerView.backgroundColor = KMRTColor.green
            headerView.text = "輕軌"
            return headerView
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard stationDetailData != nil else {return false}
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch categorySegmentedControl.selectedSegmentIndex{
        case 0:
            stationDetailData = redLine[indexPath.row]
        case 1:
            stationDetailData = orangeLine[indexPath.row]
        case 2:
            stationDetailData = klrt[indexPath.row]
        default:
            return
        }
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    func configureCell(_ cell:KMRTStationItemTableViewCell,forRowAt index:IndexPath,data:[KmrtLocationApi.Records]){
        
        let dataItem = data[index.row].fields
        cell.stationCHName.text = dataItem.stationCHName
        cell.stationENNameLabel.text = dataItem.stationENName
        cell.stationNumberLabel.text = dataItem.stationNumber
        
        switch data[index.row].fields.category{
        case "紅線":
            cell.stationNumberLabel.backgroundColor = KMRTColor.red
        case "橘線":
            cell.stationNumberLabel.backgroundColor = KMRTColor.orange
        case "輕軌":
            cell.stationNumberLabel.backgroundColor = KMRTColor.green
        default:
            cell.stationNumberLabel.backgroundColor = .black
        }
    }
}
