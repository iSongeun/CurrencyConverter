//
//  NetworkLayer.swift
//  CurrencyConverter
//
//  Created by 이송은 on 2023/03/06.
//

import Foundation

enum NetworkError : Error {
    case badurl
    case badStatusCode
}
struct NetworkLayer{
    //closure
    static func fetchJson(completion : @escaping (CurrencyModel) -> Void){
        let urlString = "https://open.er-api.com/v6/latest/USD"
        guard let url = URL(string: urlString) else {return}
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            
        }.resume()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            
            do{
                let currencyModel = try JSONDecoder().decode(CurrencyModel.self, from: data)
                
                completion(currencyModel)
                
            }catch {
                print(error)
            }
        }.resume()
    }
    
    //async await
    static func fetchJsonAsyncAwait() async throws -> CurrencyModel {
        let urlString = "https://open.er-api.com/v6/latest/USD"
        guard let url = URL(string: urlString) else {throw NetworkError.badurl}
        
        do{
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw NetworkError.badStatusCode
            }
            
            let currencyModel = try JSONDecoder().decode(CurrencyModel.self, from: data)
            
            return currencyModel
            
        }catch{
            throw error
        }
    }
}
