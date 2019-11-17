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

protocol CountriesView {
    func reloadTable()
}

class CountriesTableViewController: UIViewController, CountryTableViewCellDelegate {

    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var progressBarMemory: LinearProgressBar!
    @IBOutlet weak var freeMemoryLabel: UILabel!
    
    lazy var presenter = CountriesPresenter(view: self)
    let model = DownloaderModel()

    
    override func viewWillAppear
        (_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        setTopBarsStyle()
        
        presenter.parseMapsInfo()
        
        let diskSpace = MapsInfoService.shared.getMemoryInfo()
        freeMemoryLabel.text = "Free " + diskSpace[0] + " Gb"
        progressBarMemory.progressValue = CGFloat(100 - (Float(diskSpace[0])! / Float(diskSpace[1])! * 100))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    func onMapButtonPressed(_ cellIndex: Int) {
        presenter.downloadMap(0, cellIndex)
        presenter.changeLoadStatus(cellIndex)
        presenter.countries[cellIndex].loadStatus = .downloading
    }
}


extension CountriesTableViewController: UITableViewDataSource, UITableViewDelegate, CountriesView {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countriesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CountryTableViewCell
        let containRegions: Bool = !(presenter.countries[indexPath.row].regions!.isEmpty) // Move to presenter
        
        cell.setup(country: presenter.countries[indexPath.row].name,  // Move to presenter
                   cellIndex: indexPath.row,
                   countainRegions: containRegions,
                   laodStatus: presenter.countries[indexPath.row].loadStatus)  // Move to presenter
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(presenter.countries[indexPath.row].regions!.isEmpty) {  // Move to presenter
            let regionsViewController = storyboard!.instantiateViewController(withIdentifier: "Regions") as! RegionsViewController
            regionsViewController.countryIndex = indexPath.row
            self.model.register(regionsViewController)
            regionsViewController.model = self.model
            self.navigationController!.pushViewController(regionsViewController, animated: true)
        }
    }
    
    func reloadTable() {
        self.countriesTableView.reloadData()
    }
}

