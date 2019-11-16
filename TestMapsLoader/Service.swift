//
//  Service.swift
//  TestMapsLoader
//
//  Created by Philip on 10.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import SwiftyXMLParser

class MapsInfoService: NSObject, XMLParserDelegate {

    static let shared = MapsInfoService()
    
    //Parsing temp vars
    private var all: [Region] = []
    private var continent: Region?
    private var country: Region?
    private var region: Region?
    private var area: Region?
    private var section: Region?

    
    override private init() {
        
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
    
    // ==== PARSING ====
    
    func parseRegionsXML(completionHandler: () -> Void) {
        if let path = Bundle.main.url(forResource: "CountriesInfo", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                let complete = parser.parse()
                if complete {
                    MapsInfo.shared.setInfo(continents: all)
                    completionHandler()
                }
            }
        } else {
            debugPrint("wrong file name")
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "region" {
            var tempRegion = Region()
            if let name = attributeDict["name"] {
                tempRegion.name = name
            }
            
            if continent == nil {
                continent = tempRegion
            } else if country == nil {
                country = tempRegion
            } else if region == nil {
                region = tempRegion
            } else if area == nil {
                area = tempRegion
            } else if section == nil {
                section = tempRegion
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "region" {
            if section != nil {
                self.area?.regions?.append(section!)
                section = nil
            } else if area != nil {
                self.region?.regions?.append(area!)
                area = nil
            } else if region != nil {
                self.country?.regions?.append(region!)
                region = nil
            } else if country != nil {
                self.continent?.regions?.append(country!)
                country = nil
            } else if continent != nil {
                self.all.append(continent!)
                continent = nil
            }
        }
    }
    
    //    func readSavedRegionsInfo() {
    //        if let savedRegions = UserDefaults.standard.object(forKey: "MapsInfo") as? Data {
    //            let decoder = JSONDecoder()
    //            if let dataDecoded = try? decoder.decode([Region].self, from: savedRegions) {
    //                MapsInfo.shared.setInfo(continents: dataDecoded)
    //            }
    //        }
    //    }
    //
    //    func saveRegionsInfo() {
    //        let encoder = JSONEncoder()
    //        if let encoded = try? encoder.encode(MapsInfo.shared.getInfo()) {
    //            UserDefaults.standard.set(encoded, forKey: "MapsInfo")
    //        }
    //    }
}

