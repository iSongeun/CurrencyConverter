//
//  CurrencyModel.swift
//  CurrencyConverter
//
//  Created by 이송은 on 2023/03/06.
//

import Foundation

struct CurrencyModel : Codable {
    let result : String
    let provider : String
    let lastUpdate : String
    let baseCode : String
    let rates : [String : Double]
    
    enum CodingKeys : String, CodingKey {
        case result, provider, rates
        case lastUpdate = "time_last_update_utc"
        case baseCode = "base_code"
    }
}
