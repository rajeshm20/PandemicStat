////
////  NASAMapViewController.swift
////  
////
////  Created by RNSS on 08/04/20.
////
//
//import UIKit
//import WhirlyGlobe
//
//class NASAMapViewController: UIViewController,
//    WhirlyGlobeViewControllerDelegate,
//MaplyViewControllerDelegate {
//
//    private var theViewC: WhirlyGlobeViewController?
//    private var vectorDict: [String:Any]?
//
//    private let DoOverlay = true
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        theViewC = WhirlyGlobeViewController()
//        self.view.addSubview(theViewC!.view)
//        theViewC!.view.frame = self.view.bounds
//        addChild(theViewC!)
//
//        // we want a black background for a globe, a white background for a map.
//        theViewC!.clearColor = UIColor.black
//
//        // and thirty fps if we can get it ­ change this to 3 if you find your app is struggling
//        theViewC!.frameInterval = 3
//
//        // add the capability to use the local tiles or remote tiles
//        let useLocalTiles = false
//
//        // we'll need this layer in a second
//        let layer: MaplyQuadImageTilesLayer
//
//        if useLocalTiles {
//            guard let tileSource = MaplyMBTileSource(mbTiles: "geography-class_medres")
//            else {
//                print("Can't load 'geography-class_medres' mbtiles")
//                return
//            }
//            layer = MaplyQuadImageTilesLayer(tileSource: tileSource)!
//        }
//        else {
//            // Because this is a remote tile set, we'll want a cache directory
//            let baseCacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
//            let tilesCacheDir = "\(baseCacheDir)/tiles/"
//
//            // A set of various base layers to select from. Remember to adjust the maxZoom factor appropriately
//            // http://tile.stamen.com/terrain/
//            // http://map1.vis.earthdata.nasa.gov/wmts-webmerc/VIIRS_CityLights_2012/default/2015-05-07/GoogleMapsCompatible_Level8/{z}/{y}/{x} - jpg
//            // http://map1.vis.earthdata.nasa.gov/wmts-webmerc/MODIS_Terra_CorrectedReflectance_TrueColor/default/2015-06-07/GoogleMapsCompatible_Level9/{z}/{y}/{x}  - jpg
//
//            let maxZoom = Int32(18)
//
//            // Stamen Terrain Tiles, courtesy of Stamen Design under the Creative Commons Attribution License.
//            // Data by OpenStreetMap under the Open Data Commons Open Database License.
//
//            guard let tileSource = MaplyRemoteTileSource(
//                baseURL: "http://tile.stamen.com/terrain/",
//                ext: "jpg",
//                minZoom: 0,
//                maxZoom: maxZoom)
//            else {
//                print("Can't create the remote tile source")
//                return
//            }
//            tileSource.cacheDir = tilesCacheDir
//            layer = MaplyQuadImageTilesLayer(tileSource: tileSource)!
//        }
//
//        layer.handleEdges = true
//        layer.coverPoles = true
//        layer.requireElev = false
//        layer.waitLoad = false
//        layer.drawPriority = 0
//        layer.singleLevelLoading = false
//        theViewC!.add(layer)
//
//        // start up over Santa Cruz, center of the universe's beach
//        theViewC!.height = 0.06
//        theViewC!.heading = 0.15
//        theViewC!.tilt = 0.0         // PI/2 radians = horizon??
//        theViewC!.animate(toPosition: MaplyCoordinateMakeWithDegrees(-122.4192,37.7793), time: 1.0)
//
//        // Setup a remote overlay from NASA GIBS
//        if DoOverlay {
//            // For network paging layers, where we'll store temp files
//            let cacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
//
//            if let tileSource = MaplyRemoteTileSource(baseURL: "http://map1.vis.earthdata.nasa.gov/wmts-webmerc/Sea_Surface_Temp_Blended/default/2013-06-07/GoogleMapsCompatible_Level7/",
//                                                      ext: "png",
//                                                      minZoom: 1,
//                                                      maxZoom: 7) {
//                tileSource.cacheDir = "\(cacheDir)/sea_temperature/"
//                (tileSource.tileInfo as! MaplyRemoteTileInfo).cachedFileLifetime = 3 // invalidate OWM data after 3 secs
//                if let temperatureLayer = MaplyQuadImageTilesLayer(tileSource: tileSource) {
//                    temperatureLayer.coverPoles = false
//                    temperatureLayer.handleEdges = false
//                    theViewC!.add(temperatureLayer)
//                }
//            }
//        }
//
//        vectorDict = [
//            kMaplyColor: UIColor.white,
//            kMaplySelectable: true,
//            kMaplyVecWidth: 4.0
//        ]
//
//        // add the countries
//        addCountries()
//    }
//
//
//    private func addCountries() {
//        // handle this in another thread
//        let queue = DispatchQueue.global(qos: .background)
//        queue.async() {
//            let allOutlines = Bundle.main.paths(forResourcesOfType: "geojson", inDirectory: nil)
//
//            for outline in allOutlines {
//                if let jsonData = NSData(contentsOfFile: outline),
//                    let wgVecObj = MaplyVectorObject(fromGeoJSON: jsonData as Data) {
//                    // the admin tag from the country outline geojson has the country name ­ save
//                    if let attrs = wgVecObj.attributes,
//                        let vecName = attrs.objectForKey("ADMIN") as? NSObject {
//
//                        wgVecObj.userObject = vecName
//
//                        if vecName.description.characters.count > 0 {
//                            let label = MaplyScreenLabel()
//                            label.text = vecName.description
//                            label.loc = wgVecObj.center()
//                            label.selectable = true
//                            self.theViewC?.addScreenLabels([label],
//                                        desc: [
//                                            kMaplyFont: UIFont.boldSystemFont(ofSize: 24.0),
//                                            kMaplyTextOutlineColor: UIColor.black,
//                                            kMaplyTextOutlineSize: 2.0,
//                                            kMaplyColor: UIColor.white])
//                        }
//                    }
//
//                    // add the outline to our view
//                    let compObj = self.theViewC?.addVectors([wgVecObj], desc: self.vectorDict)
//
//                    // If you ever intend to remove these, keep track of the MaplyComponentObjects above.
//                    
//                }
//            }
//        }
//    }
//}
