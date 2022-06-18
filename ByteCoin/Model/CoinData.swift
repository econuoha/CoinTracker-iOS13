//
//  CoinData.swift
//  ByteCoin
//
//  Created by Emmanuel Onouha on 6/17/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable{
    
    let rate: Double
    let asset_id_base:String
    let asset_id_quote:String
}
