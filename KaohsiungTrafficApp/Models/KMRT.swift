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
            var address:String
            var exitCount:Int
            var stationCHName:String
            var stationENName:String
            var transfer:String?
            var latitude:Double
            var longitude:Double
            var nearExit:[String]?
            var exitNumber:[String]?
            var exitLatitude:[Double]?
            var exitLongitude:[Double]?
        }
    }
}

class KMRTColor{
    static let red = UIColor(red: 203/255, green: 43/255, blue: 70/255, alpha: 1)
    static let orange = UIColor(red: 232/255, green:158/255, blue: 59/255, alpha: 1)
    static let green = UIColor(red: 141/255, green: 186/255, blue:81/255, alpha: 1)
}


