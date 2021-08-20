//
//  MainCountryViewModel.swift
//  CovidDataTracker
//
//  Created by iMac on 07.08.2021.
//

import Foundation


struct CountryViewModel {
    
    let name: String
    let newConfirmed: Int
    let flagURL: URL?
    
    init(with country: Country) {
        self.name = country.name
        self.newConfirmed = country.today.confirmed ?? 0
        self.flagURL = URL(string: APICaller.Constants.countryFlagAPI + country.code + APICaller.Constants.snihyFlag)
    }
}
