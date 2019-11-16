//
//  CountriesModel.swift
//  TestMapsLoader
//
//  Created by Philip on 30.10.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation

enum DownloadStatus: String, Codable {
    case notAvailable
    case available
    case downloading
    case complete
}

struct Region: Codable {
    var name = ""
    var regions: [Region]? = []
    var loadStatus: DownloadStatus = .notAvailable
    var progress: Double?
}
