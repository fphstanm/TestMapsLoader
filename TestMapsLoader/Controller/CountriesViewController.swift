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

class CountriesTableViewController: UIViewController,
                                    UITableViewDataSource,
                                    UITableViewDelegate,
                                    XMLParserDelegate {
    
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
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //WTF?
        navigationController?.navigationBar.barTintColor = UIColor(hex: "#ff8800")
        print(" - - - - -  - - -")
        let diskSpace = presenter.getMemoryInfo()
        freeMemoryLabel.text = "Free " + diskSpace[0] + " Gb"
        progressBarMemory.progressValue = CGFloat(100 - (Float(diskSpace[0])! / Float(diskSpace[1])! * 100))
        
        presenter.parseRegionsXML()
        presenter.downloadMap()
    }
    
    func setupCountryCell(cell: CountryTableViewCell, country: String) {
        cell.setup(country: country)
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
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
        let cell = countriesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CountryTableViewCell
        cell.setup(country: presenter.regions[0].regions![indexPath.row].name) //TODO force unwrap
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let imageDetailController = self.storyboard!.instantiateViewController(withIdentifier: "ImageDetail") as! ImageDetailsViewController
//        let url = URL(string: "http://gallery.dev.webant.ru/media/" + (self.mainDataArray[indexPath.row].image?.contentUrl)!)
//        
//        imageDetailController.imageUrl = url
//        imageDetailController.imageName = mai´nDataArray[indexPath.row].name!
//        imageDetailController.imageDescription = mainDataArray[indexPath.row].description!

        if !(presenter.regions[0].regions![indexPath.row].regions!.isEmpty) {
            let regionsViewController = storyboard!.instantiateViewController(withIdentifier: "Regions") as! RegionsViewController
            regionsViewController.regions = presenter.regions[0].regions![indexPath.row].regions!
            print("regions: ", presenter.regions[0].regions![indexPath.row].regions!)
            self.navigationController!.pushViewController(regionsViewController, animated: true)
        } else {
            print("no regions in this country")
        }
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
