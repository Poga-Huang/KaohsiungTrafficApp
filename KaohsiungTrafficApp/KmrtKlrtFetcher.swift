//
//  KmrtKlrtFetcher.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/15.
//

import Foundation
private let apiKey = "keyuuszf5krfcrpdZ"

class KmrtKlrtFetcher{
    static let shared = KmrtKlrtFetcher()
    
    private let locaitonURL = URL(string: "https://api.airtable.com/v0/appq3eCZQEutyS0ZQ/station?sort[][field]=stationNumber&sort[][direction]=desc")!
    
    func fetchKMRTLocationData(completion:@escaping(Result<KmrtLocationApi,Error>)->()){
        var request = URLRequest(url: locaitonURL)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with:request) { (data,response,error) in
            if let data = data {
                do{
                    let kmrtResponse = try JSONDecoder().decode(KmrtLocationApi.self, from: data)
                    completion(.success(kmrtResponse))
                }catch{
                    completion(.failure(error))
                }
            }else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
