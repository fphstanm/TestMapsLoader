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

    var allRegions: [Region] = []

    
    private init() {
    }

    func getInfo() -> [Region] {
        let result = self.allRegions
        return result
    }
    
    func setInfo(continents: [Region]) {
        self.allRegions = continents
    }
    
    //TODO: write func with [index]
    func changeLoadStatus(status: DownloadStatus, regionsIndexPath: [Int]) {
        let i = regionsIndexPath
        
        switch regionsIndexPath.count {
        case 2: //country
            self.allRegions[i[0]].regions![i[1]].loadStatus = status
        case 3: //region
            self.allRegions[i[0]].regions![i[1]].regions![i[2]].loadStatus = status
        case 4: //area
            self.allRegions[i[0]].regions![i[1]].regions![i[2]].regions![i[3]].loadStatus = status
        default: //section
            self.allRegions[i[0]].regions![i[1]].regions![i[2]].regions![i[3]].regions![i[4]].loadStatus = status
        }
    }

}
