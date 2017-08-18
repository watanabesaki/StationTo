//
//  ViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/08/12.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

//インポート文追加
import GoogleMaps

import GooglePlaces

class ViewController: UIViewController {
    
    //緯度軽度
    let latitude: CLLocationDegrees = 35.689407
    let longitude: CLLocationDegrees = 139.700306
    
    //Google Maps Geocoding API リクエストの形式 出力が JSON
    let LocationUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    var apikey = ""
    
    func getKeys(){
        var keys: NSDictionary
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)!
            apikey = keys["apiKey"] as! String
            print(apikey)
        }
        
    }
    
    //表示されるときにマップを表示
    override func loadView() {
        //地図タイトル
        navigationItem.title = "Map"
        
        // マップの中心とズームレベルを指定する GMSCameraPosition オブジェクトを作成
        let camera = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude, zoom: 12.0)
        
        //GMSMapView オブジェクトをインスタンス化する際に、GMSCameraPosition オブジェクトを必須パラメータに渡す
        //GMSMapView の mapWithFrame: メソッドによって クラスを作成してインスタンス化
        //GMSMapView ビュー コントローラ上に配置するビューがこのマップだけである場合は、マップの frame に CGRectZero を指定
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //現在地オン
        mapView.isMyLocationEnabled = true
        //現在地ボタン
        mapView.settings.myLocationButton = true
        //階数ピッカー
        mapView.settings.indoorPicker = true
        //ビュー コントローラのビューに GMSMapView オブジェクトを設定
        view = mapView
        
        // マーカーの作成
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D (latitude: latitude,longitude: longitude)
        //marker.title = "Sydney"
        //marker.snippet = "Australia"
        marker.map = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getKeys()
        getLatLngForZip(zipCode: "100-0011")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    //ジオコーディングで住所から緯度軽度を取得
    func getLatLngForZip(zipCode: String) {
        let url = URL(string: "\(LocationUrl)address=\(zipCode)&key=\(apikey)")
        let jsondate = try! Data(contentsOf: url!)
        
        //Foundationオブジェクトで表現されたデータをJSONSerializationでJSONオブジェクト(Data)に変換
        let json = try! JSONSerialization.jsonObject(with: jsondate, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        print(json)
        let resultArray = json ["results"] as! NSArray
        print(resultArray)
        let result = resultArray[0] as! NSDictionary
        print(result)
        let geometry = result ["geometry"] as! NSDictionary
        print(geometry)
        var location = geometry["location"] as! NSDictionary
        print(location)
        
        var jsonlatitude = (location["lat"] as! Double)
        var jsonlongitude = (location["lng"] as! Double)
        
        print(jsonlatitude)
        print(jsonlongitude)
        //マーカーの作成
        let locationmarker = GMSMarker()
        locationmarker.position = CLLocationCoordinate2D (latitude: jsonlatitude,longitude: jsonlongitude)
        
        }
}

