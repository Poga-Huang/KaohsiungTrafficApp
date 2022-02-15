//
//  Ubike.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/13.
//

import Foundation

struct UbikeApi:Codable{
    var data:Data
    struct Data:Codable{
        var updatedAt:String
        var retVal:[RetVal]
        struct RetVal:Codable{
            var sna:String
            var sarea:String
            var ar:String
            var tot:String
            var sbi:String
            var lat:String
            var lng:String
        }
        
        enum CodingKeys:String,CodingKey{
            case updatedAt
            case retVal
        }
        enum addCodingKeys:String,CodingKey{
            case updatedAt = "updated_at"
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.retVal = try container.decode([RetVal].self, forKey: .retVal)
            if let updatedAt = try? container.decode(String.self, forKey: .updatedAt){
                self.updatedAt = updatedAt
            }else{
                let container = try decoder.container(keyedBy: addCodingKeys.self)
                self.updatedAt = try! container.decode(String.self, forKey: .updatedAt)
            }
        }
    }
}
