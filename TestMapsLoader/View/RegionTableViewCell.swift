//
//  RegionTableViewCell.swift
//  TestMapsLoader
//
//  Created by Philip on 04.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import UIKit

protocol RegionCellDelegate {
    func didPressButtonForMap(_ cellIndex: Int)
}

class RegionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var regionName: UILabel!
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var loadMapView: UIView!
    @IBOutlet weak var loadMapStatus: UIImageView!
    
    var cellIndex: Int?
    var delegate: RegionCellDelegate?
    
    
    func setup(region: String, cellIndex: Int) {
        self.cellIndex = cellIndex
        self.regionName.text = region.capitalizingFirstLetter()
        
        let loadRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedLoadMapView))
        loadRecognizer.delegate = self
        self.loadMapView.addGestureRecognizer(loadRecognizer)
        self.loadMapView.isUserInteractionEnabled = true    }
    
    func changeLoadBtnColor() {
        self.loadMapStatus.tintColor = UIColor.green
    }
    
    @objc func tappedLoadMapView() {
        self.changeLoadBtnColor()
        delegate?.didPressButtonForMap(self.cellIndex!)
    }
}
