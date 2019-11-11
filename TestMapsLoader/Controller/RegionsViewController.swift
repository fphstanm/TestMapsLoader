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
                             UITableViewDataSource,
                             UITableViewDelegate,
                             RegionCellDelegate {
    
    @IBOutlet weak var regionsTableView: UITableView!

    var countryIndex: Int?
    lazy var presenter = RegionsPresenter(view: self)

    
    override func viewWillAppear(_ animated: Bool) {
        setTopBarsStyle()
        navigationController?.navigationBar.backItem?.title = ""    }
    
    override func viewDidLoad() {
        let title = (self.presenter.countryName).capitalizingFirstLetter()
        self.navigationItem.title = title
    }
    
    func didPressButtonForMap(_ cellIndex: Int) {
        presenter.downloadMap(0, countryIndex!, cellIndex)
//        presenter.regions[cellIndex].loadStatus = .downloading
        presenter.changeLoadStatus(countryIndex: countryIndex!, regionIndex: cellIndex)
    }

}


extension RegionsViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.regions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = regionsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RegionTableViewCell
        cell.setup(region: presenter.regions[indexPath.row].name,
                   cellIndex: indexPath.row,
                   //FIXME: very bad implementation. Move it to presenter method
                   loadStatus: presenter.regions[indexPath.row].loadStatus)

        cell.delegate = self
        return cell
    }
    
    func reloadTable() {
        self.regionsTableView.reloadData()
    }
}
