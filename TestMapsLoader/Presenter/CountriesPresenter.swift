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
    lazy var continentName: String = MapsInfo.shared.allRegions[view.continentIndex].name

    init(view: CountriesTableViewController) {
        self.view = view
    }
    
    func reloadCountriesTableView() {
        self.view.reloadTable()
    }
    
    func changeLoadStatus(_ index: Int) {
        var path = [view.continentIndex]
        path.append(index)
        MapsInfo.shared.changeLoadStatus(status: .downloading, regionsIndexPath: path)
    }
    
    func parseMapsInfo() {
                //TODO appWillTerminate/Background
        //        if UserDefaults.standard.object(forKey: "MapsInfo") == nil {
                    if MapsInfo.shared.allRegions.isEmpty {
                        DispatchQueue.main.async {
                            MapsInfoService.shared.parseRegionsXML() {
                                self.countries = MapsInfo.shared.allRegions[0].regions!
                                print("parse complete")
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
}
