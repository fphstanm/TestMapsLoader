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
    let service = MapsInfoService.shared
    let dataStore = MapsInfo.shared
    var downloadedFileUrl: URL?
    lazy var countries: [Country] = MapsInfo.shared.allRegions[0].countries!
    lazy var continentName: String = MapsInfo.shared.allRegions[0].name
//    let defaults = UserDefaults.standard
        

    init(view: CountriesTableViewController) {
        self.view = view
    }
    
    func reloadCountriesTableView() {
        self.view.reloadTable()
    }
    
    func changeLoadStatus(_ index: Int) {
        dataStore.changeLoadStatus(status: .downloading, countryIndex: index)
    }

    
    func downloadMap(_ continent: Int, _ country: Int) {
        var fileName: String
        let serverStartUrl: String = "http://download.osmand.net/download.php?standard=yes&file="
        
        let continentName = self.continentName
        let countryName = self.countries[country].name
        
        fileName = countryName.capitalizingFirstLetter() + "_" + continentName + "_2.obf.zip"
        
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
            self.countries[country].loadStatus = .complete
            self.dataStore.changeLoadStatus(status: .complete, countryIndex: country) //???
            self.view.reloadTable()
        }
    }
}
    
    
//    func getCountryName(_ index: Int) -> String {
//        return self.countries![index].name
//    }
//
//    func getCountryLoadStatus(_ index: Int) -> DownloadStatus {
//        return self.mapsInfo[0].countries![index].loadStatus
//    }
//
//    func getCountryRegionsQuantity(_ index: Int) -> Int {
//        return self.mapsInfo[0].countries![index].regions!.count
//    }
//
//    func getCountryRegions(_ index: Int) -> [Region] {
//        return self.mapsInfo[0].countries![index].regions!
//    }
//
//    func getCountriesQuantity() -> Int {
//        return self.mapsInfo[0].countries!.count
//    }
    
    
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



