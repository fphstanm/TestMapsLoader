//
//  CountriesPresenter.swift
//  TestMapsLoader
//
//  Created by Philip on 29.10.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import Alamofire

class CountriesPresenter {
    
    let view: CountriesTableViewController
    var downloadedFileUrl: URL?
    var regions: [Region] = []
    let defaults = UserDefaults.standard
        

    init(view: CountriesTableViewController) {
        self.view = view
    }
    
    func reloadCountriesTableView() {
        self.view.reloadTable()
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
        
        //TODO make it easier: add func
        regionsList.forEach { continent in
            let continentName = continent.first.attributes["name"]
            let continentInfo = Region(name: continentName!, regions: [], loadStatus: .available)
            regions.append(continentInfo)
            let continentIndex = regions.count - 1
            
            continent.region.forEach { country in
                let countryName = country.first.attributes["name"]
                let countryInfo = Region(name: countryName!, regions: [], loadStatus: .available)
                regions[continentIndex].regions?.append(countryInfo)
                let countryIndex = regions[continentIndex].regions!.count - 1
                
                country.region.forEach { region in
                    let regionName = region.first.attributes["name"]
                    let area = Region(name: regionName!, regions: nil, loadStatus: .available) //TODO force unwrap
                    regions[continentIndex].regions?[countryIndex].regions?.append(area)
                }
            }
        }
    }
    
    func downloadMap(_ continent: Int, _ country: Int, _ region: Int?) {
        var fileName: String
        let serverStartUrl: String = "http://download.osmand.net/download.php?standard=yes&file="
        
        let continentName = self.regions[0].name
        let countryName = self.regions[0].regions![country].name
        
        if let region = region {
            let regionName = self.regions[0].regions![country].regions![region].name
            fileName = countryName.capitalizingFirstLetter() + "_" + regionName + "_" + continentName + "_2.obf.zip"
        } else {
            fileName = countryName.capitalizingFirstLetter() + "_" + continentName + "_2.obf.zip"
        }
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            print("fileUrl: ",fileURL)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(serverStartUrl + fileName, to: destination)
        .downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        }
        .responseData { response in
            self.downloadedFileUrl = response.fileURL

            if let region = region {
                self.regions[0].regions![country].regions![region].loadStatus = .complete
                //TODO: How to reload data??
             } else {
                 self.regions[0].regions![country].loadStatus = .complete
                 self.view.reloadTable()
             }
        }
    }
    
    //Will be soon
    
//    func readSavedRegionsInfo() {
//        if let savedRegions = self.defaults.object(forKey: "Regions") as? Data {
//            let decoder = JSONDecoder()
//            if let regionsDecoded = try? decoder.decode([Region].self, from: savedRegions) {
//                self.regions = regionsDecoded
//            }
//        }
//    }
//
//    func saveRegionsInfo() {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(self.regions) {
//            self.defaults.set(encoded, forKey: "Regions")
//        }
//    }

}

