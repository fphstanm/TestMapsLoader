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

    var allRegions: [Region]

    
    private init() {
        allRegions = [] //Or move to declaration?
    }

    func getInfo() -> [Region] {
        let result = self.allRegions
        return result
    }
    
    func setInfo(continents: [Region]) {
        self.allRegions = continents
    }

    func changeLoadStatus(status: DownloadStatus, countryIndex: Int) {
        self.allRegions[0].regions![countryIndex].loadStatus = status
    }

    func changeLoadStatus(status: DownloadStatus, countryIndex: Int, regionIndex: Int) {
        self.allRegions[0].regions![countryIndex].regions![regionIndex].loadStatus = status
    }

    func changeLoadStatus(status: DownloadStatus, countryIndex: Int, regionIndex: Int, areaIndex: Int) {
        self.allRegions[0].regions![countryIndex].regions![regionIndex].regions![areaIndex].loadStatus = status
    }
}
