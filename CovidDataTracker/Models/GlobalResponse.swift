//
//  GlobalResponse.swift
//  CovidDataTracker
//
//  Created by iMac on 07.08.2021.
//

import Foundation


struct GlobalResponse: Codable {
    
    let data: [DayData]
}


struct DayData: Codable {
    let updated_at: Date
    let date: String
    let deaths: Int?
    let confirmed: Int?
    let recovered: Int?
    let active: Int?
    let new_confirmed: Int?
    let new_recovered: Int?
    let new_deaths: Int?
}

struct DayData2: Codable {
   // let updated_at: Date
   // let date: String
   // let deaths: Int
//    let confirmed: Int?
//    let recovered: Int?
//    let active: Int?
//    let new_confirmed: Int?
//    let new_recovered: Int?
//    let new_deaths: Int?
}
