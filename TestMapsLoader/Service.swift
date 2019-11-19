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
    
    
    private init() { }
    
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
    
    
    // ==== USER DEFAULTS ====
    
    
    func startMapsInfo() {
        
        if UserDefaults.standard.object(forKey: "MapsInfo") == nil {
            if MapsInfo.shared.allRegions.isEmpty {
                DispatchQueue.main.async {
                    XMLParserForRegions.shared.parseRegionsXML {
                        print("parse complete")
                        MapsInfoService.shared.saveRegionsInfo()
                        print("write to UserDefaults")
                    }
                }
            }
        } else {
            MapsInfoService.shared.readSavedRegionsInfo()
            print("read from UserDefaults")
        }
    }
    
    func readSavedRegionsInfo() {
        if let savedRegions = UserDefaults.standard.object(forKey: "MapsInfo") as? Data {
            let decoder = JSONDecoder()
            if let dataDecoded = try? decoder.decode([Region].self, from: savedRegions) {
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

