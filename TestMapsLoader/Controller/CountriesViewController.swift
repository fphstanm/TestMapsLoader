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

class CountriesTableViewController: UIViewController,
                                    UITableViewDataSource,
                                    UITableViewDelegate,
                                    XMLParserDelegate {
    
    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var freeSpace: UILabel!
        
 
    lazy var presenter = CountriesPresenterImp(view: self)


    override func viewWillAppear
        (_ animated: Bool) {
        
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //WTF?
        navigationController?.navigationBar.barTintColor = UIColor(hex: "#ff8800")

        presenter.parseRegionsXML()
        presenter.downloadMap()
    }
    
    func setupCountryCell(cell: countryTableViewCell, country: String) {
        cell.setup(country: country)
    }


}

extension CountriesTableViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let countriesQuantity = presenter.regions[0].regions?.count else { return 0 }
        
        return countriesQuantity
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countriesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! countryTableViewCell
        cell.setup(country: presenter.regions[0].regions![indexPath.row].name) //TODO force unwrap
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let imageDetailController = self.storyboard!.instantiateViewController(withIdentifier: "ImageDetail") as! ImageDetailsViewController
//        let url = URL(string: "http://gallery.dev.webant.ru/media/" + (self.mainDataArray[indexPath.row].image?.contentUrl)!)
//        
//        imageDetailController.imageUrl = url
//        imageDetailController.imageName = mainDataArray[indexPath.row].name!
//        imageDetailController.imageDescription = mainDataArray[indexPath.row].description!
//        
        let countryRegionsViewController = self.storyboard!.instantiateViewController(withIdentifier: "CountryRegions") as! CountryRegionsViewController
        
        self.navigationController!.pushViewController(countryRegionsViewController, animated: true)
    }
    
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

//                let result = self.realm.objects(MapFile.self).filter("name = 'regionName'")
