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
    
    
    init(view: CountriesTableViewController) {
        self.view = view
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
        let xmlString = fileToString(name: "CountriesInfo", fileType: "xml")
        let xml = try! XML.parse(xmlString)
        let regionsList = xml.regions_list[0].region
        
        //TODO make it easier: add func
        regionsList.forEach { continent in
            let continentName = continent.first.attributes["name"]
            let continentInfo = Region(name: continentName!, regions: [])
            regions.append(continentInfo)
            let continentIndex = regions.count - 1
            
            continent.region.forEach { country in
                let countryName = country.first.attributes["name"]
                let countryInfo = Region(name: countryName!, regions: [])
                regions[continentIndex].regions?.append(countryInfo)
                let countryIndex = regions[continentIndex].regions!.count - 1
                
                country.region.forEach { region in
                    let regionName = region.first.attributes["name"]
                    let area = Region(name: regionName!, regions: nil) //TODO force unwrap
                    regions[continentIndex].regions?[countryIndex].regions?.append(area)
                }
            }
        }
    }
    
    func downloadMap(_ continent: String, _ country: String, _ region: String?) {
        var fileName: String
        let serverStartUrl: String = "http://download.osmand.net/download.php?standard=yes&file="
        
        if let region = region {
            fileName = country.capitalizingFirstLetter() + "_" + region + "_" + continent + "_2.obf.zip"
            print(" - fileName: ", fileName)
        } else {
            fileName = country.capitalizingFirstLetter() + "_" + continent + "_2.obf.zip"
            print(" - fileName: ", fileName)
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
        }
    }

    //TODO move it to Utility as ext
    func fileToString(name: String, fileType: String) -> String {
        var xmlString = ""
        if let path = Bundle.main.path(forResource: name, ofType: fileType) {
            do {
                xmlString = try String(contentsOfFile: path)
            } catch {
                // contents could not be loaded
            }
        }
        
        return xmlString
    }
}


