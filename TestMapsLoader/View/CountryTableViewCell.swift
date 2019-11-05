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
    
    @IBOutlet weak var mapLoadStatusView: UIView!
    @IBOutlet weak var mapLoadStatusImage: UIImageView!
    
    
    
    func setup(country: String) {
        self.countryName.text = country
        
        var loadRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeLoadBtnColor))
        loadRecognizer.delegate = self
        self.mapLoadStatusView.addGestureRecognizer(loadRecognizer)
        self.mapLoadStatusView.isUserInteractionEnabled = true
    }
    
    @objc func changeLoadBtnColor() {
        self.mapLoadStatusImage.tintColor = UIColor.green
    }
}
