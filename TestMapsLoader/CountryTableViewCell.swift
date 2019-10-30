//
//  CountryTableViewCell.swift
//  TestMapsLoader
//
//  Created by Philip on 29.10.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import UIKit

class countryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryName: UILabel!
    
    func setup(country: String) {
        //TODO if nil ...
        self.countryName.text = country
    }
//    func setup(tag: String) {
//        guard tag != " " else {
//            tagLabel.text = " "
//            return
//        }
//        tagLabel.text = "#\(tag)"
//    }
}
