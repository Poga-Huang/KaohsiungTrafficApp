//
//  UbikeFetcher.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/13.
//

import Foundation

class UbikeFetcher{
    static let shared = UbikeFetcher()
    private let url = URL(string: "https://api.kcg.gov.tw/api/service/Get/b4dd9c40-9027-4125-8666-06bef1756092")!
    
    func fetchUbikeData(completion:@escaping(Result<UbikeApi,Error>)->()){
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if let data = data {
                do{
                    let ubikeResponse = try JSONDecoder().decode(UbikeApi.self, from: data)
                    completion(.success(ubikeResponse))
                }catch{
                    completion(.failure(error))
                }
            }else if let error = error{
                completion(.failure(error))
            }
        }.resume()
    }
}
