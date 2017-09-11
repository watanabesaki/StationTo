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

import Alamofire
import SwiftyJSON

import SWXMLHash

class ViewController: UIViewController,UITextFieldDelegate, GMSAutocompleteResultsViewControllerDelegate {
    
    
    @IBOutlet var mapview: UIView!
    
    //緯度軽度
    let latitude: CLLocationDegrees = 35.689407
    let longitude: CLLocationDegrees = 139.700306
    
    //検索結果の緯度経度
    var jsonlatitude : Double = 35.689407
    var jsonlongitude : Double = 139.700306
    
    //最寄り駅の変数定義
    var closerstation : String!
    
    
    //Google Maps Geocoding API リクエストの形式 出力が JSON
    let LocationUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    var apikey = ""
    
    //SimpleAPI　最寄り駅検索
    let StationUrl = "http://map.simpleapi.net/stationapi"
    
    //駅グループAPI　駅コードから路線一覧取得
    //駅コードの変数の定義
    var Stationcode : String!
    let LineUrl = "http://www.ekidata.jp/api/g/"
    
    //路線変数の定義
    var line : [String] = []
    
    //apikeyを持ってくる
    func getKeys(){
        var keys: NSDictionary
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)!
            apikey = keys["apikey"] as! String
            //print(apikey)
        }
    }
    
    
    
    
    //GMSAutocompleteResultsViewControllerの作成
    var resultsViewController: GMSAutocompleteResultsViewController?
    //UISearchControllerを作成し、GMSAutocompleteResultsViewControllerの結果コントローラの引数として渡す
    var searchController: UISearchController?
    var resultView: UITextView?
    
    
    
    
    //表示されるときにマップを表示
    override func loadView() {
        //地図タイトル
        navigationItem.title = "Map"
        
        // マップの中心とズームレベルを指定する GMSCameraPosition オブジェクトを作成
        let camera = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude, zoom: 12.0)
        
        //GMSMapView オブジェクトをインスタンス化する際に、GMSCameraPosition オブジェクトを必須パラメータに渡す
        //GMSMapView の mapWithFrame: メソッドによって クラスを作成してインスタンス化
        //GMSMapView ビュー コントローラ上に配置するビューがこのマップだけである場合は、マップの frame に CGRectZero を指定
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: 100, height: 100), camera: camera)
        //現在地オン
        mapView.isMyLocationEnabled = true
        //現在地ボタン
        mapView.settings.myLocationButton = true
        //階数ピッカー
        mapView.settings.indoorPicker = true
        
        //padding
        let mapInsets = UIEdgeInsets(top:400.0, left:0.0, bottom:0.0, right:0)
        mapView.padding = mapInsets
        
        //ビュー コントローラのビューに GMSMapView オブジェクトを設定
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
                
        //APIkeyの読み込み
        getKeys()
        //緯度経度の取得
        getLatLngForZip(zipCode: "東京都千代田区内幸町１丁目１−６")
    
        
        //検索バーの追加
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        //検索バーの場所
        let subView = UIView(frame: CGRect(x: 3, y: 30.0, width: 370.0, height: 60.0))
        subView.isUserInteractionEnabled = true
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        //searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
        //print(json)
        let resultArray = json ["results"] as! NSArray
        //print(resultArray)
        let result = resultArray[0] as! NSDictionary
        //print(result)
        let geometry = result ["geometry"] as! NSDictionary
        //print(geometry)
        let location = geometry["location"] as! NSDictionary
        //print(location)
        
        jsonlatitude = (location["lat"] as! Double)
        jsonlongitude = (location["lng"] as! Double)
        
        print(jsonlatitude)
        print(jsonlongitude)
        
        
        getcloserstation()
        
        //マーカーの作成
        let camera = GMSCameraPosition.camera(withLatitude: jsonlatitude,
                                              longitude:jsonlongitude,
                                              zoom:15)
        let mapView = GMSMapView.map(withFrame: .zero, camera:camera)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: jsonlatitude, longitude: jsonlongitude)
        marker.map = mapView
        view = mapview
        
        
    }
    
    //Simple API　最寄り駅検索
    func getcloserstation(){
        //Int型の緯度経度を文字列型に変換
        let _ : String = "\(String(describing: jsonlatitude))"
        let jsonlongitudeString : String = "\(String(describing: jsonlongitude))"
        
        //Alamofireを使って緯度経度から最寄り駅APIを使用。SWXMLHashを使い、XMLにより取得。
        let url = "\(StationUrl)?x=\(jsonlongitudeString)&y=\(jsonlatitude)"
        Alamofire.request(url).response{ response in
            let xml = SWXMLHash.parse(response.data!)
            print(xml)
            
            //最寄り駅表示
            self.closerstation = (xml["result"]["station"][0]["name"].element?.text)
            print(self.closerstation)
            
            //マーカー表示
            

            
            
            //CSVファイルの読み込み
            self.loadCSV(filename: "station20170403free")
            
            //「駅」という文字列を削除
            if let range = self.closerstation.range(of: "駅") {
                self.closerstation.removeSubrange(range)
                print(self.closerstation)
            }

            //stationcode取得
            self.stationcode(station_name: self.closerstation)
            
        }


        /*
        let url:String = "\(StationUrl)&x=\(jsonlatitudeString)&y=\(jsonlongitudeString)"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON{ response in
            
            switch response.result {
            case .success:
                let json:JSON = JSON(response.result.value ?? kill)
                print(json)
                print(json["title"])
                print(json["description"]["text"])
                //self.showWeatherAlert(title: json["title"].stringValue,message: json["description"]["text"].stringValue)
            case .failure(let error):
                print(error)
            }
        }*/

    }
    
    /*
    func getcloserstation(){
    
        let jsonlatitudeString : String = "\(String(describing: jsonlatitude))"
        let jsonlongitudeString : String = "\(String(describing: jsonlongitude))"
        print(jsonlatitudeString)
        print(jsonlongitudeString)
        print(jsonlatitude)
        print(jsonlongitude)
        print(StationUrl)
        
        //string型をURL型を変える。URL(string 小文字。
        let url = URL(string: "\(StationUrl)&x=\(jsonlatitudeString)&y=\(jsonlongitudeString)")
        print(url)
        //URLを叩いたデータを持ってきてデータ型をjsondataに入れる
        let jsondata = try! Data(contentsOf: url!)
        //jsondataをswiftで扱えるdictionary型に変更
        let json = try! JSONSerialization.jsonObject(with: jsondata, options: JSONSerialization.ReadingOptions.mutableContainers)
        print(json)
    
    }
   */
    
    
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
        let resultStations : [String] = loadCSV(filename: "station20170403free")
        for resultStation in resultStations {
            let splitStationRow = resultStation.components(separatedBy: ",")
            if splitStationRow.count < 3 { return }
            let stationName = splitStationRow[2]
            if stationName == closerstation {
                Stationcode = splitStationRow[1]
                print(splitStationRow[1])//駅コード表示
                print(Stationcode)
                
                //Alamofireを使って緯度経度から駅グループAPIを使用。SWXMLHashを使い、XMLにより取得。
                //stationcodeを文字列型からInt型に変換
                let StationcodeInt : Int = Int(Stationcode)!
                
                let url = "\(LineUrl)\(StationcodeInt).xml"
                //print(url)
                Alamofire.request(url).response{ response in
                    let xml = SWXMLHash.parse(response.data!)
                    //print(xml)
                    
                    self.line.append((xml["ekidata"]["station_g"][0]["line_name"].element?.text)!)
                    //self.line.append((xml["ekidata"]["station_g"][1]["line_name"].element?.text)!)
                    //self.line.append((xml["ekidata"]["station_g"][2]["line_name"].element?.text)!)
                    
                    print(self.line)
                    
            }
        }
        
    }
    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面を取得
        let trainviewcontroller = segue.destination as! TrainViewController
        //次の画面の変数にこの画面の変数を入れている
        trainviewcontroller.Linemember = line
        
    }
    

}
