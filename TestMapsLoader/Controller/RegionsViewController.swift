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
    lazy var presenter = RegionsPresenter(view: self)
    
    var regionIndexPath: [Int] = []

    
    override func viewWillAppear(_ animated: Bool) {
        setTopBarsStyle()
        navigationController?.navigationBar.backItem?.title = ""    }
    
    override func viewDidLoad() {
        let title = (self.presenter.countryName).capitalizingFirstLetter()
        self.navigationItem.title = "1"
        //TODO: Add title
    }
    
    func onMapButtonPressed(_ cellIndex: Int) {
        var indexPathForMap = regionIndexPath
        indexPathForMap.append(cellIndex)
        presenter.regions[cellIndex].loadStatus = .downloading
        self.model?.addToDownloadQueue(indexPathForMap)
    }
}

extension RegionsViewController: DownloaderModelDelegate {
    
    func idGenerator(_ indices: [Int]) -> String {
        var viewControllerID = ""
        
        for i in indices {
            let sequance = String(i) + "_"
            viewControllerID.append(sequance)
        }
        return viewControllerID
    }
    
    func updateProgress(progress: Double, index: Int, viewControllerID: String) {
        let id = idGenerator(regionIndexPath)
        
        if id == viewControllerID {
            if let mapCell = self.regionsTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? RegionTableViewCell {
                mapCell.updateDisplay(progress: progress * 100)
                print(progress)
                if progress == 1.0 {
                    mapCell.progressBar.isHidden = true
                    mapCell.setLoadColor(.complete)
                    self.presenter.regions[index].loadStatus = .complete //Arch error
                } else {
                    mapCell.progressBar.isHidden = false //FIXME isHidden
                }
            }
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

        cell.setup(name: presenter.regions[indexPath.row].translate,
                   cellIndex: indexPath.row,
                   loadStatus: presenter.regions[indexPath.row].loadStatus,
                   countainRegions: containRegions)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(presenter.regions[indexPath.row].regions!.isEmpty) {  // Move to presenter
            let regionsViewController = storyboard!.instantiateViewController(withIdentifier: "Regions") as! RegionsViewController
            
            regionsViewController.regionIndexPath.append(contentsOf: self.regionIndexPath)
            regionsViewController.regionIndexPath.append(indexPath.row)
            self.model!.register(regionsViewController) //maybe move it to regionsViewCotroller init?
            regionsViewController.model = self.model //maybe move it to regionsViewCotroller init?
            self.navigationController!.pushViewController(regionsViewController, animated: true)
        }
    }
    
    func reloadTable() {
        self.regionsTableView.reloadData()
    }
}
