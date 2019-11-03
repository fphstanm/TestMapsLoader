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
import Alamofire

class CountriesTableViewController: UIViewController,
                                    UITableViewDataSource,
                                    UITableViewDelegate,
                                    XMLParserDelegate {
    
    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var freeSpace: UILabel!
        
    var regions: [Region] = []
//    var documentsURL = URL(string: "http://download.osmand.net/download.php?standard=yes&file=Germany_berlin_europe_2.obf.zip")!

    var mapFile = Data()
    var downloadedFileUrl: URL?
    var relocatedFileUrl: URL?

    override func viewWillAppear
        (_ animated: Bool) {
        
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //WTF?
        navigationController?.navigationBar.barTintColor = UIColor(hex: "#ff8800")

        parseRegionsXML()
        downloadMap()
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
                var file = MapFile()
                file.name = "regionName"
                file.archive = data
                self.downloadedFileUrl = response.fileURL
            }
        }
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
//                    print(countryName!, " ", regionName!)
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

extension CountriesTableViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.downloadedFileUrl = destinationURL
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

    //                let result = self.realm.objects(MapFile.self).filter("name = 'regionName'")
