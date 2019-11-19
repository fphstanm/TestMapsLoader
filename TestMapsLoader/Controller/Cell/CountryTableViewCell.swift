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
    func onMapButtonPressed(_ cellIndex: Int)
}

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var loadMapView: UIView!
    @IBOutlet weak var loadMapIcon: UIImageView!
    @IBOutlet weak var progressBar: LinearProgressBar!
    
    var delegate: CountryTableViewCellDelegate?
    var cellIndex: Int?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressBar.progressValue = 0
        progressBar.isHidden = true
    }
    
    func setup(country: String, cellIndex: Int, countainRegions: Bool, laodStatus: DownloadStatus) {
        self.cellIndex = cellIndex
        self.countryName.text = country.capitalizingFirstLetter()
        setLoadColor(laodStatus)
        
        if countainRegions {
            setForwardButton()
        } else {
            setLoadButton()
        }
        
        if laodStatus == .downloading {
            self.progressBar.isHidden = false 
        }
    }
    
    func updateDisplay(progress: Double, totalSize: String) {
        progressBar.progressValue = CGFloat(progress)
    }
    
    @objc func onLoadMapViewPressed() {
        setLoadColor(.downloading)
        self.progressBar.isHidden = false // FIXME isHidden
        self.loadMapView.isUserInteractionEnabled = false
        delegate?.onMapButtonPressed(self.cellIndex!)
    }
    
    
    private func setLoadColor(_ status: DownloadStatus) {
        switch status {
        case .notAvailable:
            self.loadMapIcon.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        case .available:
            self.loadMapIcon.tintColor = #colorLiteral(red: 1, green: 0.5333333333, blue: 0, alpha: 1)
        case .downloading:
            self.loadMapIcon.tintColor = #colorLiteral(red: 0.7960784314, green: 0.7803921569, blue: 0.8196078431, alpha: 1)
        case .complete:
            self.loadMapIcon.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
    }
    
    private func setLoadButton() {
        self.loadMapIcon.image = UIImage(named: "ic_custom_import")
        let loadRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLoadMapViewPressed))
        loadRecognizer.delegate = self
        
        self.loadMapView.addGestureRecognizer(loadRecognizer)
        self.loadMapView.isUserInteractionEnabled = true
    }
    
    private func setForwardButton() {
        self.loadMapIcon.image = UIImage(named: "ic_custom_forward")
        self.loadMapView.isUserInteractionEnabled = false
    }
    
}
