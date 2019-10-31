//
//  CountriesViewController.swift
//  TestMapsLoader
//
//  Created by Philip on 29.10.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import UIKit
import SwiftyXMLParser
import RealmSwift


//http://download.osmand.net/download.php?standard=yes&file=Denmark_europe_2.obf.zip

class CountriesTableViewController: UIViewController,
                                    UITableViewDataSource,
                                    UITableViewDelegate,
                                    XMLParserDelegate {
    
    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var freeSpace: UILabel!
        
    var regions: [Region] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseRegionsXML()
        

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let countriesQuantity = regions[0].regions?.count else { return 0 }
        
        return countriesQuantity
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countriesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! countryTableViewCell
        cell.setup(country: regions[0].regions![indexPath.row].name) //TODO force unwrap
        
        return cell
    }

    
    func setupCountryCell(cell: countryTableViewCell, country: String) {
        cell.setup(country: country)
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
    
    func parseRegionsXML() {
        let xmlString = fileToString(name: "CountriesInfo", fileType: "xml")
        let xml = try! XML.parse(xmlString)
        let regionsList = xml.regions_list[0].region
        
        //TODO make it easier
        regionsList.forEach { continentInfo in
            let continentName = continentInfo.first.attributes["name"]
            let continent = Region(name: continentName!, regions: [])
            regions.append(continent)
            let continentIndex = regions.count - 1
            
            continentInfo.region.forEach { countryInfo in
                let countryName = countryInfo.first.attributes["name"]
                let country = Region(name: countryName!, regions: []) //TODO mb nil?
                regions[continentIndex].regions?.append(country)
                let countryIndex = regions.count - 1
                
                countryInfo.region.forEach { region in
                    let regionName = region.first.attributes["name"]
                    let area = Region(name: regionName!, regions: nil) //TODO force unwrap
                    regions[continentIndex].regions?[countryIndex].regions?.append(area)
                    print(countryName!, " ", regionName!)
                }
            }
        }
    }
        
//    func makeCoutryObject(region: XML.Accessor) -> [Region] {
//        for index in region {
//
//        }
//        return []
//    }

    func fileToString(name: String, fileType: String) -> String {
        var xmlString = ""
        if let path = Bundle.main.path(forResource: name, ofType: fileType) {
            do {
                xmlString = try String(contentsOfFile: path)
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        return xmlString
    }
}


