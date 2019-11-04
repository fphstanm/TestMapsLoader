//
//  CountryTableViewCell.swift
//  TestMapsLoader
//
//  Created by Philip on 29.10.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var mapIcon: UIImageView!
    
    
    func setup(country: String) {
        self.countryName.text = country
    }
}
