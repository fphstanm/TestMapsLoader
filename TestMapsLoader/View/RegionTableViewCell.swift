//
//  RegionTableViewCell.swift
//  TestMapsLoader
//
//  Created by Philip on 04.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import UIKit

class RegionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var regionName: UILabel!
    @IBOutlet weak var mapIcon: UIImageView!
    
    
    func setup(region: String) {
        self.regionName.text = region
    }
}
