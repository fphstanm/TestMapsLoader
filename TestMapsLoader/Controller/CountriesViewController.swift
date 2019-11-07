//
//  CountriesViewController.swift
//  TestMapsLoader
//
//  Created by Philip on 29.10.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import UIKit
import SwiftyXMLParser
import Alamofire
import LinearProgressBar

class CountriesTableViewController: UIViewController, CountryTableViewCellDelegate {

    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var progressBarMemory: LinearProgressBar!
    @IBOutlet weak var freeMemoryLabel: UILabel!
    
    lazy var presenter = CountriesPresenter(view: self)

    
    override func viewWillAppear
        (_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        setTopBarsStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO check does it work?
        navigationController?.navigationBar.barTintColor = UIColor(hex: "#ff8800")
        let diskSpace = presenter.getMemoryInfo()
        freeMemoryLabel.text = "Free " + diskSpace[0] + " Gb"
        progressBarMemory.progressValue = CGFloat(100 - (Float(diskSpace[0])! / Float(diskSpace[1])! * 100))
        
        presenter.parseRegionsXML()
    }
    
    func didPressButtonForMap(_ cellIndex: Int) {
        presenter.downloadMap(0, cellIndex, nil)
        presenter.regions[0].regions![cellIndex].loadStatus = .downloading
    }
}


extension CountriesTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let countriesQuantity = presenter.regions[0].regions?.count else { return 0 }
        
        return countriesQuantity
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countriesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CountryTableViewCell
        let containRegions: Bool = !(presenter.regions[0].regions![indexPath.row].regions!.isEmpty)
        
        cell.setup(country: presenter.regions[0].regions![indexPath.row].name, cellIndex: indexPath.row, countainRegions: containRegions, laodStatus: presenter.regions[0].regions![indexPath.row].loadStatus) //TODO force unwrap
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(presenter.regions[0].regions![indexPath.row].regions!.isEmpty) {
            let regionsViewController = storyboard!.instantiateViewController(withIdentifier: "Regions") as! RegionsViewController
            regionsViewController.regions = presenter.regions[0].regions![indexPath.row].regions!
            regionsViewController.countryIndex = indexPath.row
            regionsViewController.presenter = self.presenter
            self.navigationController!.pushViewController(regionsViewController, animated: true)
        }
    }
}

