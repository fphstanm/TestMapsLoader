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
    func didPressButtonForMap(_ cellIndex: Int)
}

class RegionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var regionName: UILabel!
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var loadMapView: UIView!
    @IBOutlet weak var loadMapIcon: UIImageView!
    @IBOutlet weak var progressBar: LinearProgressBar!
    
    func updateDisplay(progress: Double, totalSize: String) {
        progressBar.progressValue = CGFloat(progress)
        print("cell progress: ", progressBar.progressValue)
    }
    
    var cellIndex: Int?
    var delegate: RegionCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressBar.progressValue = 0
        progressBar.isHidden = true
    }
    
    func setup(region: String, cellIndex: Int, loadStatus: DownloadStatus) {
        self.cellIndex = cellIndex
        self.regionName.text = region.capitalizingFirstLetter()
        setLoadColor(loadStatus)

        let loadRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedLoadMapView))
        loadRecognizer.delegate = self
        self.loadMapView.addGestureRecognizer(loadRecognizer)
        self.loadMapView.isUserInteractionEnabled = true
        
        if loadStatus == .downloading {
            self.progressBar.isHidden = false
        }
    }
    
    @objc func tappedLoadMapView() {
        self.setLoadColor(.downloading)
        self.progressBar.isHidden = false // FIXME isHidden
        self.loadMapView.isUserInteractionEnabled = false
        delegate?.didPressButtonForMap(self.cellIndex!)
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
