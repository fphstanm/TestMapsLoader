//
//  CountriesModel.swift
//  TestMapsLoader
//
//  Created by Philip on 30.10.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import RealmSwift

struct Region {
    var name = ""
    var regions: [Region]?
}

class MapFile: Object {
    @objc dynamic var name: String?
    @objc dynamic var archive: Data?
}
