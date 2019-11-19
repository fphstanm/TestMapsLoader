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

class CountriesPresenter: Observer {
    
    var id = "CountriesPresenter" //Observer stuff

    let view: CountriesTableViewController
    var countries: [Region] = []
    lazy var continentName: String = MapsInfo.shared.allRegions[view.continentIndex].name

    
    init(view: CountriesTableViewController) {
        self.view = view
        XMLParserForRegions.shared.add(observer: self)
    }
    
    func update(value: Bool?) { //Observer stuff
        getMapsInfo()
    }
    
    func changeLoadStatus(_ index: Int) {
        var path = [view.continentIndex]
        path.append(index)
        MapsInfo.shared.changeLoadStatus(status: .downloading, regionsIndexPath: path)
    }
    
    func getMapsInfo() {
        if !(MapsInfo.shared.allRegions.isEmpty) {
            self.countries = MapsInfo.shared.allRegions[view.continentIndex].regions!
            self.view.reloadTable()
        }
    }
}
