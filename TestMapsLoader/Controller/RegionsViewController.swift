//
//  CountryRegionsViewController.swift
//  TestMapsLoader
//
//  Created by Philip on 04.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//



import Foundation
import UIKit

class RegionsViewController: UIViewController,
                             
                             RegionCellDelegate {
    
    @IBOutlet weak var regionsTableView: UITableView!
    var model: DownloaderModel?
    var countryIndex: Int?
    var regionIndices: [Int] = []
    lazy var presenter = RegionsPresenter(view: self)

    
    override func viewWillAppear(_ animated: Bool) {
        setTopBarsStyle()
        navigationController?.navigationBar.backItem?.title = ""    }
    
    override func viewDidLoad() {
        let title = (self.presenter.countryName).capitalizingFirstLetter()
        self.navigationItem.title = title
    }
    
    func onMapButtonPressed(_ cellIndex: Int) {
//        presenter.downloadMap(0, countryIndex!, cellIndex)
        self.model?.downloadMap(0, countryIndex!, cellIndex)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.regionIndices.dropLast()
//    }
}

extension RegionsViewController: DownloaderModelDataSource, DownloaderModelDelegate {
    func getCountryIndex() -> Int {
        self.countryIndex!
    }
    
    func updateProgress(progress: Double, index: Int) {
        if let mapCell = self.regionsTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? RegionTableViewCell {
                    mapCell.updateDisplay(progress: progress * 100, totalSize: "100")
                    mapCell.progressBar.isHidden = false //FIXME isHidden
                }
    }
    
}


extension RegionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.regions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = regionsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RegionTableViewCell
        let containRegions: Bool = !(presenter.regions[indexPath.row].regions!.isEmpty) // Move to presenter

        cell.setup(region: presenter.regions[indexPath.row].name,
                   cellIndex: indexPath.row,
                   loadStatus: presenter.regions[indexPath.row].loadStatus,
                   countainRegions: containRegions)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(presenter.regions[indexPath.row].regions!.isEmpty) {  // Move to presenter
            let regionsViewController = storyboard!.instantiateViewController(withIdentifier: "Regions") as! RegionsViewController
            regionsViewController.countryIndex = indexPath.row
            regionsViewController.regionIndices.append(contentsOf: self.regionIndices)
            regionsViewController.regionIndices.append(indexPath.row)
            self.model!.register(regionsViewController)
            regionsViewController.model = self.model
            self.navigationController!.pushViewController(regionsViewController, animated: true)
        }
    }
    
    func reloadTable() {
        self.regionsTableView.reloadData()
    }
}
