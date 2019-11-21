//
//  Parser.swift
//  TestMapsLoader
//
//  Created by Philip on 19.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation

class XMLParserForRegions: NSObject, XMLParserDelegate, Observable {
    
    static let shared = XMLParserForRegions()
    
    private var all: [Region] = []
    private var continent: Region?
    private var country: Region?
    private var region: Region?
    private var area: Region?
    private var section: Region?
    
    var isParsingComplete: Bool? {
        didSet {
            notifyObservers()
        }
    }
    private var observers: [Observer] = []
    
    
    override private init() {
    }
    
    // ==== OBSERVING ====
    
    func add(observer: Observer) {
        observers.append(observer)
    }
    
    func remove(observer: Observer) {
        guard let index = observers.enumerated().first(where: { $0.element.id == observer.id })?.offset else { return }
        observers.remove(at: index)
    }
    
    func notifyObservers() {
        observers.forEach { $0.update(value: isParsingComplete) }
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
                self.isParsingComplete = true
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
            if var translate = attributeDict["translate"] {
                if translate.contains(";") {
                    translate = translate.components(separatedBy: ";")[0]
                }
                if translate.contains("=") {
                    translate = translate.components(separatedBy: "=")[1]
                }
                tempRegion.translate = translate
                
            } else {
                let name = tempRegion.name
                tempRegion.translate = name.capitalizingFirstLetter()
            }

            tempRegion.loadStatus = .available
            
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
                let sorted = self.area?.regions?.sorted(by: {$0.translate.localizedCaseInsensitiveCompare($1.translate) == ComparisonResult.orderedAscending})
                self.area?.regions = sorted
                 self.region?.regions?.append(area!)
                 area = nil
             } else if region != nil {
                let sorted = self.region?.regions?.sorted(by: {$0.translate.localizedCaseInsensitiveCompare($1.translate) == ComparisonResult.orderedAscending})
                self.region?.regions = sorted
                 self.country?.regions?.append(region!)
                 region = nil
             } else if country != nil {
                let sorted = self.country?.regions?.sorted(by: {$0.translate.localizedCaseInsensitiveCompare($1.translate) == ComparisonResult.orderedAscending})
                self.country?.regions = sorted
                 self.continent?.regions?.append(country!)
                 country = nil
             } else if continent != nil {
                let sorted = self.continent?.regions?.sorted(by: {$0.translate.localizedCaseInsensitiveCompare($1.translate) == ComparisonResult.orderedAscending})
                self.continent?.regions = sorted
                 self.all.append(continent!)
                 continent = nil
             }
         }
     }
}
