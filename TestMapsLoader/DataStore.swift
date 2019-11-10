//
//  DataStore.swift
//  TestMapsLoader
//
//  Created by Philip on 10.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation

class MapsInfo {

    static let shared = MapsInfo()

    var allRegions: [Continent]

    
    private init() {
        allRegions = [] //Or move to declaration?
    }

    func setInfo(continents: [Continent]) {
        self.allRegions = continents
    }

    func changeLoadStatus(status: DownloadStatus, countryIndex: Int) {
        self.allRegions[0].countries![countryIndex].loadStatus = status
    }

    func changeLoadStatus(status: DownloadStatus, countryIndex: Int, regionIndex: Int) {
        self.allRegions[0].countries![countryIndex].regions![regionIndex].loadStatus = status
    }

    func changeLoadStatus(status: DownloadStatus, countryIndex: Int, regionIndex: Int, areaIndex: Int) {
        self.allRegions[0].countries![countryIndex].regions![regionIndex].areas![areaIndex].loadStatus = status
    }
}
