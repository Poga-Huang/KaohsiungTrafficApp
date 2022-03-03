//
//  KmrtLiveBoardFetcher.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/3/2.
//

import Foundation
import CryptoKit

class KmrtLiveBoardFetcher{
    
    static let shared = KmrtLiveBoardFetcher()
    
    private let appId = "fd9192aa133d44899bc36f54b7ac854d"
    private let appKey = "wuXtTjjl67ELJk-M1Jvs7xHznbU"
    private let baseURL = URL(string: "https://ptx.transportdata.tw/MOTC/v2/Rail/Metro/LiveBoard/KRTC?%24top=500&%24format=JSON")!
    
    func getTimeString()->String{
        //request的時間
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let time = dateFormatter.string(from: Date())
        return time
    }
    
    func getAuthorization(xdate:String)->String{
        //request時間
        let signDate = "x-date:\(xdate)"
        //對appKey做加密
        let key = SymmetricKey(data: Data(appKey.utf8))
        //用SHA256做加密
        let hmac = HMAC<SHA256>.authenticationCode(for: Data(signDate.utf8), using: key)
        //對加密做編碼
        let base64HmacString = Data(hmac).base64EncodedString()
        let authorization = """
        hmac username="\(appId)",algorihm="hmac-sha256",headers="x-date",signature="\(base64HmacString)"
        """
        return authorization
    }
    
    func fetchKmrtLiveBoardData(){
        let xdate = getTimeString()
        let authorization = getAuthorization(xdate: xdate)
        var request = URLRequest(url: baseURL)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
            }else{
                print("error")
            }
        }.resume()
    }
    
    
}
