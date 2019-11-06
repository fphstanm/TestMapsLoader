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
        let continentName = presenter.regions[0].name //TODO: To make continent avaliable pass its index here
        let countryName = presenter.regions[0].regions![cellIndex].name
        presenter.downloadMap(continentName, countryName, nil)
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
        cell.setup(country: presenter.regions[0].regions![indexPath.row].name, cellIndex: indexPath.row, countainRegions: containRegions) //TODO force unwrap
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

//TODO: Move it to Utility.swift
extension CountriesTableViewController {
    
    func setTopBarsStyle() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.5333333333, blue: 0, alpha: 1)
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height

            let statusbarView = UIView()
            statusbarView.backgroundColor = #colorLiteral(red: 1, green: 0.5333333333, blue: 0, alpha: 1)
            view.addSubview(statusbarView)

            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true

        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = #colorLiteral(red: 1, green: 0.5333333333, blue: 0, alpha: 1)
        }
    }
}
