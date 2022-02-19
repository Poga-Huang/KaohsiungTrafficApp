//
//  Transprotation+Enum.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/10.
//

import Foundation

//首頁清單
enum TransportationItem:String,CaseIterable{
    case bike = "Ubike"
    case mrt = "高雄捷運"
    case bus = "公車"
    case heart = "常用路線"
}

enum MrtListItem:String,CaseIterable{
    case routeSettings = "路線設定"
    case station = "站點查詢"
    case systemPhoto = "營運系統圖"
}
enum MrtListItemDescription:String,CaseIterable{
    case routeSettingsDescription = "可設定起點站與終點站得知票價與時間"
    case stationDescription = "查詢捷運站點地址、周圍資訊...等"
    case systemPhotoDescription = "查看目前最新捷運系統路網圖"
}
