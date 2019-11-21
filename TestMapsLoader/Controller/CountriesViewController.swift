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

    var continentIndex = 0 //If continents were available, you would write method to get the current continent
    
    
    override func viewWillAppear
        (_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        setTopBarsStyle()
        presenter.getMapsInfo()
        setDiskSpace()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.register(self as! CountriesTableViewController) //TODO make unregister
    }
    
    func onMapButtonPressed(_ cellIndex: Int) {
        var indexPathForMap = [continentIndex]
        indexPathForMap.append(cellIndex)
        self.model.addToDownloadQueue(indexPathForMap)
    }
    
    private func setDiskSpace() {
        let diskSpace = MapsInfoService.shared.getMemoryInfo()
        freeMemoryLabel.text = "Free " + diskSpace[0] + " Gb"
        progressBarMemory.progressValue = CGFloat(100 - (Float(diskSpace[0])! / Float(diskSpace[1])! * 100))
    }
}

extension CountriesTableViewController: DownloaderModelDelegate {
    
    private func generateID(_ indices: [Int]) -> String {
        var viewControllerID = ""
        
        for i in indices {
            let sequance = String(i) + "_"
            viewControllerID.append(sequance)
        }
        return viewControllerID
    }
    
    func updateProgress(progress: Double, index: Int, viewControllerID: String) {
        let id = generateID([continentIndex])
        
        if id == viewControllerID {
            if let mapCell = self.countriesTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CountryTableViewCell {
                mapCell.updateDisplay(progress: progress * 100)
                mapCell.progressBar.isHidden = false //FIXME isHidden
                print(progress)
                 if progress == 1.0 {
                     mapCell.progressBar.isHidden = true
                     mapCell.setLoadColor(.complete)
                     self.presenter.countries[index].loadStatus = .complete //Arch error
                 } else {
                     mapCell.progressBar.isHidden = false //FIXME isHidden
                 }
            }
        }
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
        
        cell.setup(name: presenter.countries[indexPath.row].translate,  // Move to presenter
                   cellIndex: indexPath.row,
                   countainRegions: containRegions,
                   laodStatus: presenter.countries[indexPath.row].loadStatus)  // Move to presenter
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(presenter.countries[indexPath.row].regions!.isEmpty) {  // Move to presenter
            let regionsViewController = storyboard!.instantiateViewController(withIdentifier: "Regions") as! RegionsViewController

            var countryIndexPath: [Int] = [continentIndex]
            countryIndexPath.append(indexPath.row)
            regionsViewController.regionIndexPath = countryIndexPath
            self.model.register(regionsViewController) //maybe move it to regionsViewCotroller init?
            regionsViewController.model = self.model //maybe move it to regionsViewCotroller init?
            self.navigationController!.pushViewController(regionsViewController, animated: true)
        }
    }
    
    func reloadTable() {
        self.countriesTableView.reloadData()
    }
}


