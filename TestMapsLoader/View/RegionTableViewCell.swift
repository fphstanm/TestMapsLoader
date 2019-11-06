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
        self.loadMapView.isUserInteractionEnabled = true
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
    

    

}
