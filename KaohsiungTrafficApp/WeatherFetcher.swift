//
//  WeatherFetcher.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/11.
//

import UIKit
import MapKit

private let apiKey = "1df065a80a3ec76b1b35f26181fad3a3"

class WeatherFetcher{
    static let shared = WeatherFetcher()
    
    func fetchKaohsiungWeatherData(completion:@escaping (Result<WeatherApi,Error>)->()){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Kaohsiung&appid=\(apiKey)") else{return}
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if let data = data {
                do{
                    let weatherResponse = try JSONDecoder().decode(WeatherApi.self, from: data)
                    completion(.success(weatherResponse))
                }catch{
                    completion(.failure(error))
                }
            }else if let error = error{
                completion(.failure(error))
            }
        }.resume()
    }
}
//    func fetchLocationWeatherData(latitude:CLLocationDegrees,longitude:CLLocationDegrees,completion:@escaping(Result<WeatherApi,Error>)->()){
//        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)")else{return}
//        URLSession.shared.dataTask(with: url) { (data,response,error) in
//            if let data = data {
//                do{
//                    let weatherResponse = try JSONDecoder().decode(WeatherApi.self, from: data)
//                    completion(.success(weatherResponse))
//                }catch{
//                    completion(.failure(error))
//                }
//            }else if let error = error{
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//}
