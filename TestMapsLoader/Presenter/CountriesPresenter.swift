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
    var countries: [Region] = []
    lazy var continentName: String = MapsInfo.shared.allRegions[0].name
//    let defaults = UserDefaults.standard

    init(view: CountriesTableViewController) {
        self.view = view
        if !(MapsInfo.shared.allRegions.isEmpty), let regions = MapsInfo.shared.allRegions[0].regions {
            self.countries = regions //eto nenujno
        } else {
            debugPrint("regions are empty")
        }
    }
    
    func reloadCountriesTableView() {
        self.view.reloadTable()
        print("reloaded")
    }
    
    func changeLoadStatus(_ index: Int) {
        MapsInfo.shared.changeLoadStatus(status: .downloading, countryIndex: index)
    }
    
    func parseMapsInfo() {
                //TODO appWillTerminate/Background
        //        if UserDefaults.standard.object(forKey: "MapsInfo") == nil {
                    if MapsInfo.shared.allRegions.isEmpty {
                        DispatchQueue.main.async {
                            MapsInfoService.shared.parseRegionsXML() {
                                self.countries = MapsInfo.shared.allRegions[0].regions!
                                print("complete")
                                self.reloadCountriesTableView()
                            }
                        }
        //                MapsInfoService.shared.saveRegionsInfo()
                    }
        //        } else {
        //            MapsInfoService.shared.readSavedRegionsInfo()
        //        }
        // dumaju
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
            //TODO mb DispachQueue .. async
            //FIXME display status in particalar cell !
            if let mapCell = self.view.countriesTableView.cellForRow(at: IndexPath(row: country, section: 0)) as? CountryTableViewCell {
                mapCell.updateDisplay(progress: (progress.fractionCompleted) * 100, totalSize: "100")
                mapCell.progressBar.isHidden = false //FIXME isHidden
            }
        }
        .responseData { response in
            self.countries[country].loadStatus = .complete
            MapsInfo.shared.changeLoadStatus(status: .complete, countryIndex: country) //???
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
