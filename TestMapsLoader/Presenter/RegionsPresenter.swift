//
//  RegionsPresenter.swift
//  TestMapsLoader
//
//  Created by Philip on 07.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import Alamofire

class RegionsPresenter {
    
    let view: RegionsViewController
    var regions: [Region] = []
    let defaults = UserDefaults.standard
    
    
    init(view: RegionsViewController) {
        self.view = view
    }
    
    func reloadTable() {
        self.view.reloadTable()
    }
    
    func downloadMap(_ continent: Int, _ country: Int, _ region: Int?) {
        var fileName: String
        let serverStartUrl: String = "http://download.osmand.net/download.php?standard=yes&file="
        
        let continentName = self.regions[0].name
        let countryName = self.regions[0].regions![country].name
        let regionName = self.regions[0].regions![country].regions![region!].name
        
        fileName = countryName.capitalizingFirstLetter() + "_" + regionName + "_" + continentName + "_2.obf.zip"
        
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
            self.regions[0].regions![country].regions![region!].loadStatus = .complete
            self.view.reloadTable()
        }
    }
    
}



//        let indexPath = IndexPath(item: country, section: 0)
//        self.countriesTableView.beginUpdates()
//        self.countriesTableView.reloadRows(at: [indexPath], with: .automatic)
//        self.countriesTableView.endUpdates()

// // put it to cell
//func showProgress(){
//    print("   DateCell showProgress") // this does get printed
//    self.setNeedsDisplay()
//}

//NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)

//extension DownloadStatus {
//
//    private enum CodingKeys: String, CodingKey {
//        case notAvailable = "notAvailable"
//        case available = "available"
//        case downloading = "downloading"
//        case complete = "complete"
//    }
//
//    enum PostTypeCodingError: Error {
//        case decoding(String)
//    }
//}
