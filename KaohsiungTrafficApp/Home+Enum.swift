//
//  Transprotation+Enum.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/10.
//

import Foundation

//let locations = ["高雄全區","楠梓區","左營區","鼓山區","鹽埕區","三民區","前金區","新興區","苓雅區","前鎮區","小港區","旗津區","鳳山區","鳥松區","仁武區","大社區","大樹區","大寮區","林園區","岡山區","橋頭區","路竹區","燕巢區","阿蓮區","田寮區","梓官區","彌陀區","永安區","湖内區","茄萣區","旗山區","美濃區","內門區","杉林區","甲仙區","六龜區","那瑪夏區","桃源區","茂林區"]

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

