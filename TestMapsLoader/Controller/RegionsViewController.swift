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
                             UITableViewDelegate {
    
    @IBOutlet weak var regionsTableView: UITableView!

    var regions: [Region] = []


    override func viewWillAppear(_ animated: Bool) {
        
        setTopBarsStyle()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(regions.count)
        return regions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = regionsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RegionTableViewCell
        cell.setup(region: regions[indexPath.row].name)

        return cell
    }

    func setupRegionCell(cell: RegionTableViewCell, region: String) {
        cell.setup(region: region)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //TODO: Move it to Utility.swift
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
