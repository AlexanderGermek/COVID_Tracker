//
//  Models.swift
//  CovidDataTracker
//
//  Created by iMac on 06.08.2021.
//

import Foundation

struct CovidDataResponse: Codable {
    
    let data: [Country]
}

struct Country: Codable {
    
    var coordinates: CountryCoordinates
    let name: String
    let code: String
    let population: Int?
    let updated_at: Date
    let latest_data: LatestData
    let today: TodayData
    let timeline: [DayData]?
}

struct CountryCoordinates: Codable {
    let latitude: Float?
    let longitude: Float?
}

struct LatestData: Codable {
    let deaths: Int?
    let confirmed: Int?
    let recovered: Int?
    let critical: Int?
    let calculated: CalculatedData
    
}

struct TodayData: Codable {
    let deaths: Int?
    let confirmed: Int?
}

struct CalculatedData: Codable { //все данные в процентах %
    let death_rate: Float?
    let recovery_rate: Float?
    let recovered_vs_death_ratio: Float?
    let cases_per_million_population: Float?
}
