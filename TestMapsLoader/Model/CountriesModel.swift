//
//  CountriesModel.swift
//  TestMapsLoader
//
//  Created by Philip on 30.10.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation

enum DownloadStatus: Int, Codable {
    case notAvailable = 1
    case available = 2
    case downloading = 3
    case complete = 4 
}

struct Region: Codable {
    var name = ""
    var regions: [Region]?
    var loadStatus: DownloadStatus = .notAvailable
}

extension DownloadStatus {
    
    private enum CodingKeys: String, CodingKey {
        case notAvailable = "notAvailable"
        case available = "available"
        case downloading = "downloading"
        case complete = "complete"
    }
    
    enum PostTypeCodingError: Error {
        case decoding(String)
    }
}
//
//enum PostType: Codable {
//    case count(number: Int)
//    case title(String)
//}
//
//extension PostType {
//
//    private enum CodingKeys: String, CodingKey {
//        case count
//        case title
//    }
//
//    enum PostTypeCodingError: Error {
//        case decoding(String)
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        if let value = try? values.decode(Int.self, forKey: .count) {
//            self = .count(number: value)
//            return
//        }
//        if let value = try? values.decode(String.self, forKey: .title) {
//            self = .title(value)
//            return
//        }
//        throw PostTypeCodingError.decoding("Whoops! \(dump(values))")
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        switch self {
//        case .count(let number):
//            try container.encode(number, forKey: .count)
//        case .title(let value):
//            try container.encode(value, forKey: .title)
//        }
//    }
//}
