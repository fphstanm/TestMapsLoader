//
//  CountryRegionsViewController.swift
//  TestMapsLoader
//
//  Created by Philip on 04.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import UIKit

class CountryRegionsViewController: UIViewController,
                                    UITableViewDataSource,
                                    UITableViewDelegate {
    
    @IBOutlet weak var countryRegionsTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = countryRegionsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! countryTableViewCell

        return cell
    }
}
