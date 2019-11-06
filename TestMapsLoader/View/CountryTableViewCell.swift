//
//  CountryTableViewCell.swift
//  TestMapsLoader
//
//  Created by Philip on 29.10.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import UIKit
import LinearProgressBar

protocol CountryTableViewCellDelegate {
    func didPressButtonForMap(_ cellIndex: Int)
}

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var loadMapView: UIView!
    @IBOutlet weak var loadMapStatus: UIImageView!
    @IBOutlet weak var progressBar: LinearProgressBar!
    
    var delegate: CountryTableViewCellDelegate?
    var cellIndex: Int?
    
    
    func setup(country: String, cellIndex: Int) {
        self.cellIndex = cellIndex
        self.countryName.text = country.capitalizingFirstLetter()
        let loadRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedLoadMapView))
        loadRecognizer.delegate = self
        
        self.loadMapView.addGestureRecognizer(loadRecognizer)
        self.loadMapView.isUserInteractionEnabled = true
    }
    
    func changeLoadBtnColor() {
        self.loadMapStatus.tintColor = UIColor.green
    }
    
    @objc func tappedLoadMapView() {
        self.changeLoadBtnColor()
        delegate?.didPressButtonForMap(self.cellIndex!)
        
    }
}

//        let countryUp = String((country.prefix(1).capitalized).dropFirst())


