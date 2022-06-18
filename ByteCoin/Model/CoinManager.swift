//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdateRate(_ coinManager: CoinManager, coinModel: CoinModel)
    func didFailWithError(_ error:Error)
}

struct CoinManager {
    
    var delegate:CoinManagerDelegate?
    var baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "redacted"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    mutating func changeBaseUrl(to currency: String){
        baseURL = "https://rest.coinapi.io/v1/exchangerate/\(currency)"
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let coinModel = self.parseJSON(safeData){
                        let modelToPass = CoinModel(rate: coinModel.rate, base: coinModel.base, quote: coinModel.quote)
                        self.delegate?.didUpdateRate(self, coinModel: modelToPass)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate.round(to: 2)
            let base = decodedData.asset_id_base
            let quote = decodedData.asset_id_quote
            
            let modelToPass = CoinModel(rate: rate, base: base, quote: quote)
            
            return modelToPass
        }
        catch{
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}

extension Double{
    func round(to num: Int) -> Double{
        
        let places = Double(num)
        
        let powOfNum = pow(10.0, places)
        
        var bigNum = self * powOfNum
        
        bigNum.round()
        
        bigNum = bigNum / powOfNum
        
        return bigNum
        
    }
}
