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

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var mapIcon: UIImageView!
    
    @IBOutlet weak var mapLoadStatusView: UIView!
    @IBOutlet weak var mapLoadStatusImage: UIImageView!
    
    @IBOutlet weak var progressBar: LinearProgressBar!
    
    
    func setup(country: String) {
//        let countryUp = String((country.prefix(1).capitalized).dropFirst())
        self.countryName.text = country.capitalizingFirstLetter()
        let loadRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeLoadBtnColor))
        loadRecognizer.delegate = self
        self.mapLoadStatusView.addGestureRecognizer(loadRecognizer)
        self.mapLoadStatusView.isUserInteractionEnabled = true
    }
    
    @objc func changeLoadBtnColor() {
        self.mapLoadStatusImage.tintColor = UIColor.green
    }
    
    func changeLoadingProgress(_ percent: Int) {
        progressBar.progressValue = CGFloat(percent)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
