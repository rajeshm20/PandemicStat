//
//  ViewController.swift
//  PandemicStat
//
//  Created by Rajesh M on 30/03/20.
//  Copyright © 2020 Rajesh M. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var affectedNoLabel: UILabel!
    @IBOutlet var recoveredNoLabel: UILabel!
    @IBOutlet var deadNoLabel: UILabel!
    @IBOutlet var crtiticaNoLabel: UILabel!
    @IBOutlet var countryCollectionView: UICollectionView!
    
    let rapidCoronaStatTotalURL = "https://covid-19-data.p.rapidapi.com/totals"
    let rapidCoronaStatByCountryURL = "https://covid-19-data.p.rapidapi.com/country/code"
    var flags = [UIImage]()
    var countries: [Country] = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.global(qos: .background).async {
            
            self.fetchCoronaStat(ur: self.rapidCoronaStatTotalURL, alpha2Code: "")
        }
        
        
        
        countryCollectionView.collectionViewLayout = CarouselFlowLayout()
        
        countries = self.readJson(filename: "Countries")!
        
        print("CountriesCount->\(String(describing: countries.count))")
        print("Countries->\(String(describing: countries[150].name))")
    }
    
    func readJson(filename fileName: String) -> [Country]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Country].self, from: data)
                return jsonData
                
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func fetchCoronaStat(ur: String, alpha2Code: String){
        
        
        var parameters = [String: String]()
        if alpha2Code != "" {
            
            parameters = [
                
                "format": "undefined",
                "code": "\(alpha2Code)"
            ]
            
        } else {
            
            parameters = [
                
                "format": "undefined",
            ]
            
            
        }
        
        
        let headers: HTTPHeaders = [
            
            "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
            "x-rapidapi-key": "f446c84865msh0fc29ed5a477740p1ebd05jsn4eb4d4704788"
        ]
        
        
        Alamofire.request(ur, parameters: parameters, headers: headers).responseJSON { response in
            debugPrint(response)
            
            if response.data != nil {
                
            if alpha2Code == "" {
                do {
                    
                    let data = Data(response.data!)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode([TotalResponse].self, from: data).first
                
                    DispatchQueue.main.async {
                        self.affectedNoLabel.text = jsonData?.confirmed ?? "-"
                        self.crtiticaNoLabel.text = jsonData?.critical ?? "-"
                        self.deadNoLabel.text = jsonData?.deaths ?? "-"
                        self.recoveredNoLabel.text = jsonData?.recovered ?? "-"
                    }
                    
                } catch {
                    
                    
                }
                    
                } else {
                    
                do {
                    
                    let data = Data(response.data!)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode([CountryResponse].self, from: data).first
                    
                    DispatchQueue.main.async {
                        
                        self.affectedNoLabel.text = "\(String(describing: jsonData?.confirmed ?? 0))"
                        self.crtiticaNoLabel.text = "\(String(describing: jsonData?.critical ?? 0))"
                        self.deadNoLabel.text = "\(String(describing: jsonData?.deaths ?? 0))"
                        self.recoveredNoLabel.text = "\(String(describing: jsonData?.recovered ?? 0))"
                    }
                    
                } catch {
                    
                    
                }
                
                }

                }
            }
        }
        
    
    
    
    func getImage(){
        
        let fileManager = FileManager.default
               let bundleURL = Bundle.main.bundleURL
               let assetURL = bundleURL.appendingPathComponent("CountryPickerView.bundle/Images/") // Bundle URL
               do {
                   let contents = try fileManager.contentsOfDirectory(at: assetURL,
                                                                      includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey],
                                                                      options: .skipsHiddenFiles)
                   
                   for item in contents { // item is the URL of everything in MyBundle imgs or otherwise.
                       print("itemURL: \(item)")
                       let image = UIImage(contentsOfFile: item.path) // Initializing an image
                       flags.append(image!) // Adding the image to the icons array
                       
                   }
               }
                   
               catch let error as NSError {
                   print(error)
               }
               
               print("fags-count: \(flags.count)")
               print("fags-array: \(flags)")
               
    }
    
    
}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        countries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let countryCell = countryCollectionView.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as! CountryCollectionCell
        
        countryCell.countryNameLabel.text = countries[indexPath.row].name
        
        print("imagename: \(self.countries[indexPath.row].alpha2Code!)")
        let imgName = self.countries[indexPath.row].alpha2Code!
        let image = UIImage(named: "\(imgName).png")
        
        countryCell.flagImageView.image = image
        
        
        return countryCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(String(describing: countries[indexPath.row].name)) selected")
        
        DispatchQueue.global(qos: .background).async{
            
            let alpha2Code:String = (self.countries[indexPath.row].alpha2Code?.lowercased())!
            debugPrint("checkAlpha2: \(alpha2Code)")
            self.fetchCoronaStat(ur: self.rapidCoronaStatByCountryURL, alpha2Code:alpha2Code)
            
        }
    }
    
    
    
}









//        var bundleURL:URL?=nil
//        bundleURL = Bundle.main.url(forResource: "CountryPickerView", withExtension: "bundle")?.appendingPathComponent("/Images/")
//         bundleURL = Bundle.main.bundleURL
//        let assetURL = bundleURL!.appendingPathComponent("CountryPickerView.bundle/Images/")

//        print("bundleURL: \(String(describing: bundleURL))")
//        if bundleURL != nil {
//            let bundle = Bundle(url: bundleURL!)
//            print("bundle: \(String(describing: bundle))")
//            print("countryaplph2code: \(String(describing: self.countries[indexPath.row].alpha2Code)))")
//            let imageURL = bundle!.url(forResource: "\(String(describing: self.countries[indexPath.row].alpha2Code))", withExtension: "png", subdirectory: "Images")
//            print("imageURL: \(String(describing: imageURL))")
//            let image = UIImage(contentsOfFile: imageURL!.path)
//            countryCell.flagImageView.image = image
//        } else {
//
//            print("Image not found")
//        }
