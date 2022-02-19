//
//  KMRT.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/15.
//

import UIKit

struct KmrtLocationApi:Codable{
    var records:[Records]
    struct Records:Codable{
        var fields:Fields
        struct Fields:Codable{
            var category:String
            var stationNumber:String
            var stationCHName:String
            var stationENName:String
            var latitude:Double
            var longitude:Double
        }
    }
}

struct KmrtLiveBoardApi:Codable{
    var records:[Records]
    struct Records:Codable{
        var TripHeadSign:String
        var EstimateTime:Int
        var StationName:stationName
        struct stationName:Codable{
            var name:String
            
            enum CodingKeys:String,CodingKey{
                case name = "zh_tw"
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.name = try container.decode(String.self, forKey: .name)
            }
        }
    }
}

class KMRTColor{
    static let red = UIColor(red: 203/255, green: 43/255, blue: 70/255, alpha: 1)
    static let orange = UIColor(red: 232/255, green:158/255, blue: 59/255, alpha: 1)
    static let green = UIColor(red: 141/255, green: 186/255, blue:81/255, alpha: 1)
}


