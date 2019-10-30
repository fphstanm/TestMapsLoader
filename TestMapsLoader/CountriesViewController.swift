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

struct Book {
    var bookTitle: String
    var bookAuthor: String
}

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
        
        return regions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = countriesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! countryTableViewCell
        cell.setup(country: regions[indexPath.row].name)
        
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
        
        regionsList.forEach { continent in
            continent.region.forEach { countryInList in
                let countryName = countryInList.first.attributes["name"]
                let country = Region(name: countryName!, regions: []) //TODO mb nil?
                regions.append(country)
                let currentIndex = regions.count - 1
                
                countryInList.region.forEach { region in
                    let regionName = region.first.attributes["name"]
                    let area = Region(name: regionName!, regions: nil) //TODO force unwrap
                    regions[currentIndex].regions?.append(area)
                    print(countryName!, " ", regionName!)
                }
            }
        }
    }
        
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


