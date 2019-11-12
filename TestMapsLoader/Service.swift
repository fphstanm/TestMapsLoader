//
//  Service.swift
//  TestMapsLoader
//
//  Created by Philip on 10.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import SwiftyXMLParser

class MapsInfoService {

    static let shared = MapsInfoService()

    
    private init() {
        
    }
    
    func getMemoryInfo() -> [String] {
        let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
        var totalAndAvailableMemory: [String] = []
        do {
            let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey])

            if let capacity = values.volumeAvailableCapacityForImportantUsage, let total = values.volumeTotalCapacity {
                var capacityStr = (String(capacity).dropLast(7))
                capacityStr.insert(".", at: capacityStr.index(capacityStr.endIndex, offsetBy: -2))
                var totalStr = String(total).dropLast(7)
                totalStr.insert(".", at: totalStr.index(totalStr.endIndex, offsetBy: -2))
                
                totalAndAvailableMemory.append(contentsOf: [String(capacityStr),String(totalStr)])
            }
        } catch {
            print("Error retrieving capacity: \(error.localizedDescription)")
        }

        return totalAndAvailableMemory
    }
    
    func parseRegionsXML() {
         let xmlString = String().fileToString(name: "CountriesInfo", type: "xml")
         let xml = try! XML.parse(xmlString)
         let regionsList = xml.regions_list[0].region
         var tempMaps: [Continent] = []
         
         //TODO make it easier: add func
         regionsList.forEach { continent in
             let continentName = continent.first.attributes["name"]
             let continentInfo = Continent(name: continentName!, countries: [], loadStatus: .available)
             tempMaps.append(continentInfo)
             let continentIndex = tempMaps.count - 1
             
             continent.region.forEach { country in
                 let countryName = country.first.attributes["name"]
                 let countryInfo = Country(name: countryName!, regions: [], loadStatus: .available)
                 tempMaps[continentIndex].countries?.append(countryInfo)
                 let countryIndex = tempMaps[continentIndex].countries!.count - 1
                 
                 country.region.forEach { regionInf in
                     let regionName = regionInf.first.attributes["name"]
                     let region = Region(name: regionName!, areas: [], loadStatus: .available) //TODO force unwrap
                     tempMaps[continentIndex].countries?[countryIndex].regions?.append(region)
                     let regionIndex = tempMaps[continentIndex].countries![countryIndex].regions!.count - 1
                     
                     regionInf.region.forEach { area in
                         let areaName = area.first.attributes["name"]
                         let area = Area(name: areaName!, loadStatus: .available)
                         tempMaps[continentIndex].countries?[countryIndex].regions![regionIndex].areas!.append(area)
                     }
                 }
             }
         }
         
         let dataStore = MapsInfo.shared
         dataStore.setInfo(continents: tempMaps)
         print(tempMaps.count)
     }
    
    // USER DEFAULTS
    
    func readSavedRegionsInfo() {
        if let savedRegions = UserDefaults.standard.object(forKey: "MapsInfo") as? Data {
            let decoder = JSONDecoder()
            if let dataDecoded = try? decoder.decode([Continent].self, from: savedRegions) {
                MapsInfo.shared.setInfo(continents: dataDecoded)
            }
        }
    }

    func saveRegionsInfo() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(MapsInfo.shared.getInfo()) {
            UserDefaults.standard.set(encoded, forKey: "MapsInfo")
        }
    }
}
