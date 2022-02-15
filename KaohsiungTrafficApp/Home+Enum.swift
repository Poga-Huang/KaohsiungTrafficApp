//
//  Transprotation+Enum.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/10.
//

import Foundation



enum TransportationItem:String,CaseIterable{
    case bike
    case mrt
    case bus
    case heart
}
enum TransportationName:String,CaseIterable{
    case bike = "Ubike"
    case mrt = "高雄捷運"
    case bus = "公車"
    case heart = "常用路線"
}

