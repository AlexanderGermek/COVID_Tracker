//
//  APICaller.swift
//
//  Created by iMac on 06.08.2021.
//

import Foundation
import Alamofire

final class APICaller {
    
    static let shared = APICaller()
    
    struct Constants {
        static let mainAPI    = "https://corona-api.com"
        static let countries  = "/countries"
        static let globalData = "https://corona-api.com/timeline"
        
        static let countryFlagAPI = "https://www.countryflags.io/"
        static let flatFlag       = "/flat/64.png"
        static let snihyFlag      = "/shiny/64.png"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    func getAllCountriesData(completion: @escaping (Result<[Country], Error>) -> Void) {
        
        guard let url = URL(string: Constants.mainAPI + Constants.countries) else {
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                
                case .success(_):
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(DateFormatter.isoDateFormatter)
                        let covidData = try decoder.decode(CovidDataResponse.self, from: response.data!)
                        completion(.success(covidData.data))
                        //                    let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments)
                        //                    print(json)
                        
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                }
                
            }
    }
    
    
    func getGlobalData(completion: @escaping (Result<[DayData], Error>) -> Void) {
        
        guard let url = URL(string: Constants.globalData) else {
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                
                case .success(_):
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(DateFormatter.isoDateFormatter)
                        let covidGlobalData = try decoder.decode(GlobalResponse.self, from: response.data!)
                        completion(.success(covidGlobalData.data))
                        //                    let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments)
                        //                    print(json)
                        
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                }
                
            }
    }
    
    func getCountryData(code: String, completion: @escaping (Result<CountryResponse, Error>) -> Void) {
    
        guard let url = URL(string: Constants.mainAPI + Constants.countries + "/\(code)") else {
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                
                case .success(_):
                    
                    do {
                        //print(response.data ?? 0)
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(DateFormatter.isoDateFormatter)
                        let countryData = try decoder.decode(CountryResponse.self, from: response.data!)
                        completion(.success(countryData))
//                        let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments)
//                        print(json)
                        
                    } catch let error as NSError {
                        print("Failed to load2: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("Request error2: \(error.localizedDescription)")
                }
                
            }
    
    
    }
    
    
}
