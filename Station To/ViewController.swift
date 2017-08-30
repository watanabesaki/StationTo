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
    
    //検索結果の緯度経度
    var jsonlatitude : Double = 35.689407
    var jsonlongitude : Double = 139.700306
    
    //Google Maps Geocoding API リクエストの形式 出力が JSON
    let LocationUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    var apikey = ""
    
    //SimpleAPI　最寄り駅検索
    let StationUrl = "http://map.simpleapi.net/stationapi/?output=json"
    
    //apikeyを持ってくる
    func getKeys(){
        var keys: NSDictionary
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)!
            apikey = keys["apikey"] as! String
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
        //let marker = GMSMarker()
        //marker.position = CLLocationCoordinate2D (latitude: latitude,longitude: longitude)
        //marker.title = "Sydney"
        //marker.snippet = "Australia"
        //marker.map = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //APIkeyの読み込み
        getKeys()
        //緯度経度の取得
        getLatLngForZip(zipCode: "東京都千代田区内幸町１丁目１−６")
        //最寄り駅取得
        getcloserstation()
        //CSVファイルの読み込み
        loadCSV(filename: "station20170403free")
        //stationcode取得
        stationcode(station_name: "新宿")
        //CSVファイルの読み込み
        loadCSV(filename: "line20170403free")
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    //ジオコーディングで住所から緯度軽度を取得
    func getLatLngForZip(zipCode: String) {
        
        let rawUrl = "\(LocationUrl)address=\(zipCode)&key=\(apikey)"
        //URLエンコーディング(日本語→%)
        let encodedUrl = rawUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: encodedUrl!)
        
        let jsondata = try! Data(contentsOf: url!)
        
        //Foundationオブジェクトで表現されたデータをJSONSerializationでJSONオブジェクト(Data)に変換
        let json = try! JSONSerialization.jsonObject(with: jsondata, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        print(json)
        let resultArray = json ["results"] as! NSArray
        print(resultArray)
        let result = resultArray[0] as! NSDictionary
        print(result)
        let geometry = result ["geometry"] as! NSDictionary
        print(geometry)
        let location = geometry["location"] as! NSDictionary
        print(location)
        
        jsonlatitude = (location["lat"] as! Double)
        jsonlongitude = (location["lng"] as! Double)
        
        print(jsonlatitude)
        print(jsonlongitude)
        
        //マーカーの作成
        let camera = GMSCameraPosition.camera(withLatitude: jsonlatitude,
                                              longitude:jsonlongitude,
                                              zoom:15)
        let mapView = GMSMapView.map(withFrame: .zero, camera:camera)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: jsonlatitude, longitude: jsonlongitude)
        marker.map = mapView
        view = mapView
        }
    
    //Simple API　最寄り駅検索
    func getcloserstation(){
    
        let jsonlatitudeString : String = "\(String(describing: jsonlatitude))"
        let jsonlongitudeString : String = "\(String(describing: jsonlongitude))"
        print(jsonlatitudeString)
        print(jsonlongitudeString)
        print(jsonlatitude)
        print(jsonlongitude)
        print(StationUrl)
        
        /*
        let url = URL(String: "\(StationUrl)&x=\(jsonlatitudeString)&y=\(jsonlongitudeString)")
        print(url)
        let jsondate = try! Data(contentsOf: url!)
        let json = try! JSONSerialization.jsonObject(with: jsondate, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        print(json)
        */
    
    }
    
    
    //CSVファイルの読み込みメソッド。引数にファイル名、返り値にString型の配列。
    func loadCSV(filename:String)->[String]{
        //CSVファイルを格納するための配列を作成
        var csvArray : [String] = []
        
        //CSVファイルの読み込み
        let csvBundle = Bundle.main.path(forResource: filename, ofType: "csv")
        
        do {
            //csvBundleのパスを読み込み、UTF8に文字コード変換して、NSStringに格納
            let csvData = try String(contentsOfFile: csvBundle!,
                                     encoding: String.Encoding.utf8)
            //改行コードが"\r"で行なわれている場合は"\n"に変更する
            //let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            //"\n"の改行コードで区切って、配列csvArrayに格納する
            //csvArray = lineChange.components(separatedBy: "\n")
            
            csvArray = csvData.components(separatedBy:"\n")
            
        }
        catch {
            print("CSVファイル読み込みエラー")
        }
        print("CSVファイル読み込み完了")
        return csvArray
        

        // ファイル名がquizmondai.scvファイルの場合は以下のように形で呼ぶ
        // let resultArray:[String] = loadCSV("quizmondai")

    }
    
    
    //駅から路線コード取得、路線一覧取得
    func stationcode (station_name:String){
        //駅名から駅コードを取得
        var resultStation : [String] = loadCSV(filename: "station20170403free")
        var resultStationRow = resultStation[2]
        let splitStationRow = resultStationRow.components(separatedBy: ",")
        print(splitStationRow[5]) //路線コード取得
        
        //路線コードから路線を取得
        let resultLine : [String] = loadCSV(filename: "line20170403free")
        let resultLineRow = resultLine[1]
        let splitLineRow = resultLineRow.components(separatedBy: ",")
        print(splitLineRow[2]) //路線取得
        
    }
    
    
    

}
