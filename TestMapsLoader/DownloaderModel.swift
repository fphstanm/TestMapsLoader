//
//  DownloaderService.swift
//  TestMapsLoader
//
//  Created by Philip on 17.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import Alamofire
protocol DownloaderModelDelegate: class {
    func updateProgress(progress: Double, index: Int)
}

protocol DownloaderModelDataSource: class {
    func getCountryIndex() -> Int
}

class DownloaderModel {
    let dataStore = MapsInfo.shared
    // some tableViews (region, country)
    // u kazdogo region table view, est svoj countryIndex + region index
    private var delegates = NSHashTable<AnyObject>.weakObjects()
    
    func register(_ controller: DownloaderModelDelegate & DownloaderModelDataSource) {
        self.delegates.add(controller)
    }
    
    func downloadMap(_ continent: Int, _ country: Int, _ region: Int) {
        var fileName: String
        let serverStartUrl: String = "http://download.osmand.net/download.php?standard=yes&file="
        
        let continentName = MapsInfo.shared.allRegions[0].name
        let countryName = self.dataStore.allRegions[0].regions![country].name
        let regionName = self.dataStore.allRegions[0].regions![country].regions![region].name
        
        fileName = countryName.capitalizingFirstLetter() + "_" + regionName + "_" + continentName + "_2.obf.zip"
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            print("fileUrl: ",fileURL)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

//        self.dataStore.allRegions[continent].regions![region].loadStatus = .downloading
        self.dataStore.changeLoadStatus(status: .downloading, countryIndex: country, regionIndex: region)

        AF.download(serverStartUrl + fileName, to: destination)
            .downloadProgress { [weak self] progress in
                if let all = self?.delegates.allObjects {
                    for delegate in all {
                        if let d = delegate as? DownloaderModelDelegate & DownloaderModelDataSource {
                            if d.getCountryIndex() == country {
                                d.updateProgress(progress: progress.fractionCompleted, index: region)
                            }
                            
                        }
                    }
                }
                //TODO mb DispachQueue .. async
                //               if let mapCell = self.delegate?.regionsTableView.cellForRow(at: IndexPath(row: region, section: 0)) as? RegionTableViewCell {
                //                   mapCell.updateDisplay(progress: (progress.fractionCompleted) * 100, totalSize: "100")
                //                   mapCell.progressBar.isHidden = false //FIXME isHidden
                //               }
        }
        .responseData { response in
//            self.dataStore.allRegions[0].regions![country].regions![region].loadStatus = .complete
            self.dataStore.changeLoadStatus(status: .complete, countryIndex: country, regionIndex: region) //????
//               self.delegate?.reloadTable()
        }
    }}
