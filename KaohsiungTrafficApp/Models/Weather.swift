//
//  WeatherAPI.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/11.
//

import Foundation

struct WeatherApi:Codable{
    var weather:[Weather]
    struct Weather:Codable{
        var id:Int
    }
    var main:Main
    struct Main:Codable{
        var temp:Float
        var feelsLike:Float
        var humidity:Int
        
        enum CodingKeys:String,CodingKey{
            case temp
            case feelsLike
            case humidity
        }
        enum addCodingkeys:String,CodingKey{
            case feelsLike = "feels_like"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.temp = try container.decode(Float.self, forKey: .temp)
            self.humidity = try container.decode(Int.self, forKey: .humidity)
            
            if let feelsLike = try? container.decode(Float.self, forKey: .feelsLike){
                self.feelsLike = feelsLike
            }else{
                let container = try decoder.container(keyedBy: addCodingkeys.self)
                self.feelsLike = try! container.decode(Float.self, forKey: .feelsLike)
            }
        }
    }
}
