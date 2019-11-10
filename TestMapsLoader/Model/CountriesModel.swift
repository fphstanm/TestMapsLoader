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
    var regions: [Region]?
    var loadStatus: DownloadStatus = .notAvailable
}

/*
struct Continent: Codable {
    var name = ""
    var regions: [Country]?
    var loadStatus: DownloadStatus = .notAvailable
}

struct Country: Codable {
    var name = ""
    var regions: [Region]?
    var loadStatus: DownloadStatus = .notAvailable
}

struct Region: Codable {
    var name = ""
    var regions: [Area]?
    var loadStatus: DownloadStatus = .notAvailable
}

struct Area: Codable {
    var name = ""
    var loadStatus: DownloadStatus = .notAvailable
}
*/
