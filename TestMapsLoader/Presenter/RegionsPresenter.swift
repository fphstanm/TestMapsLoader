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
    var regions: [Region]

    var countryName: String = ""
    let dataStore = MapsInfo.shared
    
    init(view: RegionsViewController) {
        self.view = view

        var tempRegions = MapsInfo.shared.allRegions
        for i in self.view.regionIndexPath {
            tempRegions = tempRegions[i].regions!
        }
        self.regions = tempRegions
    }
    
    func reloadTable() {
        self.view.reloadTable()
    }
    
    func changeLoadStatus(countryIndex: Int, regionIndex: Int) {
        var path = view.regionIndexPath
        path.append(regionIndex)
        print(path)
        MapsInfo.shared.changeLoadStatus(status: .downloading, regionsIndexPath: path)
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
