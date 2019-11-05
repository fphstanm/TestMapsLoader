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
    
    func getMemoryInfo() {
        let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
        do {
            let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            if let capacity = values.volumeAvailableCapacityForImportantUsage {
                print("Available capacity for important usage: \(capacity)")
            } else {
                print("Capacity is unavailable")
            }
        } catch {
            print("Error retrieving capacity: \(error.localizedDescription)")
        }
    }
    
    func downloadMap() {
//        AF.download("https://www.hq.nasa.gov/alsj/a17/A17_FlightPlan.pdf")
//        AF.download("http://download.osmand.net/download.php?standard=yes&file=Germany_berlin_europe_2.obf.zip")
//        AF.download("https://httpbin.org/image/png") //, to: destination
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("image.png")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download("https://httpbin.org/image/png", to: destination)
        .downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        }
        .responseData { response in
            if let data = response.value {
                self.downloadedFileUrl = response.fileURL
            }
        }
    }
    
    func parseRegionsXML() {
        let xmlString = fileToString(name: "CountriesInfo", fileType: "xml")
        let xml = try! XML.parse(xmlString)
        let regionsList = xml.regions_list[0].region
        
        //TODO make it easier
        regionsList.forEach { continent in
            let continentName = continent.first.attributes["name"]
            let continentInfo = Region(name: continentName!, regions: [])
            regions.append(continentInfo)
            let continentIndex = regions.count - 1
            print("continent index", continentIndex)
            
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
        print(regions.count)
    }
    
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


extension Data {
    func sizeString(units: ByteCountFormatter.Units = [.useAll], countStyle: ByteCountFormatter.CountStyle = .file) -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = units
        bcf.countStyle = .file

        return bcf.string(fromByteCount: Int64(count))
    }
    
}
