//
//  RegionTableViewCell.swift
//  TestMapsLoader
//
//  Created by Philip on 04.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import UIKit
import LinearProgressBar

protocol RegionCellDelegate {
    func onMapButtonPressed(_ cellIndex: Int)
}

class RegionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var regionName: UILabel!
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var loadMapView: UIView!
    @IBOutlet weak var loadMapIcon: UIImageView!
    @IBOutlet weak var progressBar: LinearProgressBar!
    
    var cellIndex: Int?
    var delegate: RegionCellDelegate?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressBar.isHidden = true
        progressBar.progressValue = 0.0
    }
    
    func setup(name: String, cellIndex: Int, loadStatus: DownloadStatus, countainRegions: Bool) {
        self.cellIndex = cellIndex
        self.regionName.text = name
        setLoadColor(loadStatus)

        if countainRegions {
            setForwardButton()
        } else {
            setLoadButton(loadStatus)
        }
        
        if loadStatus == .downloading {
            self.progressBar.isHidden = false
        } else if loadStatus == .complete {
            self.progressBar.isHidden = true
        }
    }
    
    func updateDisplay(progress: Double) {
        progressBar.progressValue = CGFloat(progress)
    }
    
    @objc func onLoadMapViewPressed() {
        self.setLoadColor(.downloading)
        self.progressBar.isHidden = false // FIXME isHidden
        self.loadMapView.isUserInteractionEnabled = false
        delegate?.onMapButtonPressed(self.cellIndex!)
    }
    
    private func setLoadButton(_ downloadStatus: DownloadStatus) {
        self.loadMapIcon.image = UIImage(named: "ic_custom_import")
        let loadRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLoadMapViewPressed))
        loadRecognizer.delegate = self
        self.loadMapView.addGestureRecognizer(loadRecognizer)

        switch downloadStatus {
        case .downloading, .notAvailable, .complete:
            self.loadMapView.isUserInteractionEnabled = false
        case .available:
            self.loadMapView.isUserInteractionEnabled = true
        }
    }
    
    private func setForwardButton() {
        self.loadMapIcon.image = UIImage(named: "ic_custom_forward")
        self.loadMapView.isUserInteractionEnabled = false
    }
    
    func setLoadColor(_ status: DownloadStatus) {
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
    
    

}
