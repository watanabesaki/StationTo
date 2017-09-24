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
import GooglePlacePicker

import NCMB

class ViewController: UIViewController,UITextFieldDelegate, GMSAutocompleteResultsViewControllerDelegate,GMSMapViewDelegate {
    
    
    /*
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
    */
    
    let zoomRate: Float = 16.0
    
    var locationManager: CLLocationManager!
    
    var lastLocation: CLLocationCoordinate2D?
    
    var searchedLocation: CLLocationCoordinate2D!
    
    var placesClient: GMSPlacesClient!
    
    //UIViewではなくGMSMapVIew
    @IBOutlet var mapView: GMSMapView!

    
    /*
    //apikeyを持ってくる
    func getKeys(){
        var keys: NSDictionary
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)!
            apikey = keys["apikey"] as! String
            print(apikey)
        }
    }
    */
    
    
    
    //GMSAutocompleteResultsViewControllerの作成
    var resultsViewController: GMSAutocompleteResultsViewController?
    //UISearchControllerを作成し、GMSAutocompleteResultsViewControllerの結果コントローラの引数として渡す
    var searchController: UISearchController?
    var resultView: UITextView?
    
    
    
    /*
    //表示されるときにマップを表示
    override func loadView() {
        /*
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
         */
    }
   */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView?.delegate = self
        
        setUpSearchController()
        
        //現在地
        placesClient = GMSPlacesClient.shared()
        
        //前回の現在地を表示
        loadLastLocation()
        //現在地取得
        loadCurrentLocation()
        
        /*
        //APIkeyの読み込み
        getKeys()
        //緯度経度の取得
        //getLatLngForZip(zipCode: "東京都千代田区内幸町１丁目１−６")
    
        
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
        
        //ナビゲーションバーの非表示
        navigationController?.navigationBar.isTranslucent = false
        searchController?.hidesNavigationBarDuringPresentation = false
        // This makes the view area include the nav bar even though it is opaque.
        // Adjust the view placement down.
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
         */
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadLocations()
    }

    /*
    override func viewDidAppear(_ animated: Bool) {
        searchController?.searchBar.becomeFirstResponder()
    }
    */
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let stationViewController = segue.destination as! StationViewController
        stationViewController.location = searchedLocation
    }
    

    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false
        // Do something with the selected place.
        
        searchedLocation = place.coordinate
        
        //場所検索後、地図表示、マーカー表示
        self.mapView.animate(toZoom: 16.0)
        self.mapView.animate(toLocation: place.coordinate)
        createMarker(position: place.coordinate, name: place.name)
        
        }
    
    //map
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    //map
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    //map
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    // MARK: - MapDelegate
    func mapView(_ mapView: GMSMapView, didTapMarker marker: GMSMarker) {
        
        //マーカーをタップした時のアラート
        let actionSheet = UIAlertController(title: marker.snippet, message: "この場所を選択しますか？", preferredStyle: .actionSheet)
        let searchAction = UIAlertAction(title: "最寄り駅を検索", style: .default) { (action) in
            self.searchedLocation = marker.position
            self.performSegue(withIdentifier: "ToTrain", sender: nil)
        }
        
        let checkinAction = UIAlertAction(title: "チェックイン", style: .default) { (action) in
             Place.shared.name = marker.snippet
             GMSPlacesClient.shared().location = marker.position
            self.tabBarController?.selectedIndex = 1
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            
        }
        actionSheet.addAction(searchAction)
        actionSheet.addAction(checkinAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Private マーカー作成関数
    func createMarker(position: CLLocationCoordinate2D, name: String?) {
        let marker = GMSMarker()
        marker.position = position
        if let name = name {
            marker.snippet = name
        }
        // marker.icon = UIImage(named: "")
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = self.mapView
    }
    
    //現在地を取得する
    func loadCurrentLocation() {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print(error.code)
                switch error.code {
                case -11:
                    self.locationManager = CLLocationManager()
                    self.locationManager.requestAlwaysAuthorization()
                default :
                    print(error.localizedDescription)
                    break
                }
                return
            } else {
                if let placeLikelihoodList = placeLikelihoodList {
                    
                    let place = placeLikelihoodList.likelihoods.first?.place
                    if let place = place {
                        // print(place.name)
                        // print(place.formattedAddress!.components(separatedBy: ", ").joined(separator: "\n"))
                        
                        self.createMarker(position: place.coordinate, name: place.name)
                        //UDに保存
                        self.saveLastLocation(location: place.coordinate)
                    }
                }
            }
        })
    }
    
    //前回の保存してある現在地を取得
    func loadLastLocation() {
        if let lastLocationInfo = UserDefaults.standard.dictionary(forKey: "lastLocation") {
            let latitude = lastLocationInfo["latitude"] as! CLLocationDegrees
            let longitude = lastLocationInfo["longitude"] as! CLLocationDegrees
            lastLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            if let lastLocation = lastLocation {
                self.mapView.animate(toZoom: zoomRate)
                self.mapView.animate(toLocation: lastLocation)
            }
        }
    }
    
    //現在地を保存
    func saveLastLocation(location: CLLocationCoordinate2D) {
        
        let lastLocationInfo = ["latitude": Double(location.latitude),
                                "longitude": Double(location.longitude)]
        
        let ud = UserDefaults.standard
        ud.set(lastLocationInfo, forKey: "lastLocation")
        ud.synchronize()
    }
    
    func loadLocations() {
        
        self.mapView?.clear()
        
        let query = NCMBQuery(className: "Place")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("error")
            } else {
                let places = result as! [NCMBObject]
                for place in places {
                    let longitude = place.object(forKey: "longitude") as! Double
                    let latitude = place.object(forKey: "latitude") as! Double
                    let name = place.object(forKey: "name") as! String
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    self.createMarker(position: location, name: name)
                }
            }
        })
    }
    
    func setUpSearchController() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        definesPresentationContext = true
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

    
    /*
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
        
        //エラー対処アラート
        if json["error_message"] != nil {
            let alert = UIAlertController(title: "エラー", message: json["error_message"] as! String, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "リロード", style: .default, handler: { (action) in
                self.getLatLngForZip(zipCode: zipCode)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        let resultArray = json ["results"] as! NSArray
        print(resultArray)
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
            //self.loadCSV(filename: "station20170403free")
            
            //「駅」という文字列を削除
            if let range = self.closerstation.range(of: "駅") {
                self.closerstation.removeSubrange(range)
                print(self.closerstation)
            }

            //stationcode取得
            //self.Stationcode(station_name: self.closerstation)
            
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

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面を取得
        let trainviewcontroller = segue.destination as! TrainViewController
        //次の画面の変数にこの画面の変数を入れている
        trainviewcontroller.Linemember = line
        
    }
    */



