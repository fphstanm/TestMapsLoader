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
    
    
    func setup(country: String, cellIndex: Int, countainRegions: Bool) {
        self.cellIndex = cellIndex
        self.countryName.text = country.capitalizingFirstLetter()
        
        if countainRegions {
            setForwardImage()
        } else {
            setLoadButton()
        }
    }
    
    @objc func tappedLoadMapView() {
        self.changeLoadBtnColor(isLoaded: false)
        self.loadMapView.isUserInteractionEnabled = false
        delegate?.didPressButtonForMap(self.cellIndex!)
    }
    
    func changeLoadBtnColor(isLoaded: Bool) {
        if isLoaded {
            self.loadMapStatus.tintColor = UIColor.green
        } else {
            self.loadMapStatus.tintColor = #colorLiteral(red: 0.7960784314, green: 0.7803921569, blue: 0.8196078431, alpha: 1)
        }
    }
    
    func setLoadButton() {
        let loadRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedLoadMapView))
        loadRecognizer.delegate = self
        
        self.loadMapView.addGestureRecognizer(loadRecognizer)
        self.loadMapView.isUserInteractionEnabled = true
    }
    
    func setForwardImage() {
        self.loadMapStatus.image = UIImage(named: "ic_custom_forward")
    }
}
