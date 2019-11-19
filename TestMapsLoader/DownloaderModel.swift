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
    func updateProgress(progress: Double, index: Int, viewControllerID: String)
}

class DownloaderModel {
    let dataStore = MapsInfo.shared
    
    private var delegates = NSHashTable<AnyObject>.weakObjects()
    
    func register(_ controller: DownloaderModelDelegate) {
        self.delegates.add(controller)
    }
    
    
    func downloadMap(_ regionsIndices: [Int]) {
        let fileName = formFileName(regionsIndices)
        let serverStartUrl: String = "http://download.osmand.net/download.php?standard=yes&file="
        let viewControllerID = generateId(regionsIndices)

        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            print("fileUrl: ",fileURL)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        self.dataStore.changeLoadStatus(status: .downloading, regionsIndexPath: regionsIndices)

        AF.download(serverStartUrl + fileName, to: destination)
            .downloadProgress { [weak self] progress in
                if let all = self?.delegates.allObjects {
                    for delegate in all {
                        if let d = delegate as? DownloaderModelDelegate {
                            d.updateProgress(progress: progress.fractionCompleted, index: regionsIndices.last!, viewControllerID: viewControllerID)
                        }
                    }
                }
        }
        .responseData { response in
            self.dataStore.changeLoadStatus(status: .complete, regionsIndexPath: regionsIndices)
            //FIXME move it out
            MapsInfoService.shared.saveRegionsInfo()
        }
    }
    
    private func generateId(_ indices: [Int]) -> String {
        var viewControllerID = ""
        var indicesTmp = indices
        indicesTmp.remove(at: indicesTmp.count - 1)
        for i in indicesTmp {
            let sequance = String(i) + "_"
            viewControllerID.append(sequance)
        }
        return viewControllerID
    }
    
    func formFileName(_ regionsIndices: [Int]) -> String {
        let continentName = MapsInfo.shared.allRegions[regionsIndices[0]].name
        let countryName = MapsInfo.shared.allRegions[regionsIndices[0]].regions![regionsIndices[1]].name //Save country name
        
        var tempName = ""
        var tempRegion = MapsInfo.shared.allRegions[regionsIndices[0]].regions![regionsIndices[1]]
        
            
        var indecies = regionsIndices
        indecies.remove(at: 0) //Delete continent
        indecies.remove(at: 0) //Delete country
        
        if !(indecies.isEmpty) {
            for index in indecies {
                tempRegion = tempRegion.regions![index]
                tempName += "_" + tempRegion.name
            }
        }

        return countryName.capitalizingFirstLetter() + tempName + "_" + continentName + "_2.obf.zip"
    }
    
}
