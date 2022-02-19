//
//  HomeCollectionViewController.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/10.
//

import UIKit

private let reuseIdentifier = "itemCell"
private let reusableViewIdentifier = "weatherCell"

class HomeCollectionViewController: UICollectionViewController {
    
    
   
    //交通工具
    private struct SegueIdentifier{
        static let ubike = "selectUbike"
        static let mrt = "selectMRT"
        static let bus = "selectBus"
        static let heart = "selectFavorites"
    }
    var weatherData:WeatherApi?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchWeatherInfoData()
    }
    
    //抓資料
    func fetchWeatherInfoData(){
        WeatherFetcher.shared.fetchWeatherData { result in
            switch result{
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self.weatherData = weatherResponse
                    self.collectionView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.displayError {
                        self.fetchWeatherInfoData()
                    }
                }
            }
        }
    }
    
    //選擇交通工具
    @IBAction func selectTransportation(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            performSegue(withIdentifier: SegueIdentifier.ubike, sender: nil)
        case 1:
            performSegue(withIdentifier: SegueIdentifier.mrt, sender: nil)
        case 2:
            performSegue(withIdentifier: SegueIdentifier.bus, sender: nil)
        case 3:
            performSegue(withIdentifier: SegueIdentifier.heart, sender: nil)
        default:
            return
        }
    }

    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeItemCollectionViewCell
        configure(cell, forRowAt: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reusableViewIdentifier, for: indexPath) as? WeatherCollectionReusableView else{return UICollectionReusableView()}
        
        guard let weatherData = weatherData else {return reusableView}
        configureReusableView(view: reusableView, data: weatherData)
        
        return reusableView
    }
    
   
}

