//
//  CheckinViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/08/31.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

import GooglePlaces

import GooglePlacePicker
import NCMB
import SVProgressHUD

import Alamofire
import SwiftyJSON
import SWXMLHash


class CheckinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    var locationManager: CLLocationManager!
    
    //googleplace現在地の取得
    var placesClient: GMSPlacesClient!
    
    //検索した場所の名前
    //var searchName : String!
    //var searchlocation : CLLocationCoordinate2D!

    
    //駅名入力
    @IBOutlet var stationInput : UITextField!
    var stationInputList : [String] = []
    
    //最寄り駅検索で使用
    //var stationoption : String = ""
    //var stationcity : String!
    //var cityList : [String] = []
    
    //路線入力
    @IBOutlet var lineInput : UITextField!
    var lineInputList : [String] = ["JR山手線",
                                    "JR京浜東北線",
                                    "JR中央線(快速)",
                                    "JR総武本線",
                                    "JR中央本線(東京～塩尻)",
                                    "JR中央・総武緩行線",
                                    "JR横須賀線",
                                    "JR埼京線",
                                    "JR湘南新宿ライン",
                                    "上野東京ライン",
                                    "JR高崎線",
                                    "JR南武線",
                                    "JR青梅線",
                                    "JR武蔵野線",
                                    "JR川越線",
                                    "東京メトロ銀座線",
                                    "東京メトロ丸ノ内線",
                                    "東京メトロ日比谷線",
                                    "東京メトロ東西線",
                                    "東京メトロ千代田線",
                                    "東京メトロ有楽町線",
                                    "東京メトロ半蔵門線",
                                    "東京メトロ南北線",
                                    "東京メトロ副都心線",
                                    "JR鶴見線",
                                    "JR横浜線",
                                    "JR根岸線",
                                    "R相模線",
                                    "JR東海道本線(東京～熱海)",
                                    "JR五日市線",
                                    "JR八高線(八王子～高麗川)",
                                    "JR八高線(高麗川～高崎)",
                                    "JR外房線",
                                    "JR内房線",
                                    "JR京葉線",
                                    "JR成田線",
                                    "JR成田エクスプレス",
                                    "東武東上線",
                                    "東武伊勢崎線",
                                    "東武野田線",
                                    "東武越生線",
                                    "西武池袋線",
                                    "西武秩父線",
                                    "西武有楽町線",
                                    "西武豊島線",
                                    "西武狭山線",
                                    "西武新宿線",
                                    "西武拝島線",
                                    "西武西武園線",
                                    "西武国分寺線",
                                    "西武多摩湖線",
                                    "西武多摩川線",
                                    "京成本線",
                                    "京成押上線",
                                    "京成金町線",
                                    "京成千葉線",
                                    "京成千原線",
                                    "京成成田空港線",
                                    "京王線",
                                    "京王相模原線",
                                    "京王高尾線",
                                    "京王競馬場線",
                                    "京王動物園線",
                                    "京王井の頭線",
                                    "京王新線",
                                    "小田急小田原線",
                                    "小田急江ノ島線",
                                    "小田急多摩線",
                                    "東急東横線",
                                    "東急目黒線",
                                    "東急田園都市線",
                                    "東急大井町線",
                                    "東急池上線",
                                    "東急多摩川線",
                                    "東急世田谷線",
                                    "東急こどもの国線",
                                    "京急本線",
                                    "京急空港線",
                                    "京急大師線",
                                    "京急逗子線",
                                    "京急久里浜線",
                                    ]
    
    //駅コード変数
    var stationCodes = [String]()
    
    //出口入力
    @IBOutlet var exitInput : UITextField!
    
    // 何両目
    @IBOutlet var numberOfLineInput : UITextField!
    let numberOfLineInputList = ["","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    
    //何分
    @IBOutlet var timeInput : UITextField!
    let timeinputList = ["","3","5","10","15","20","25","30","40","50","60"]
    
    //駅名と場所の配列
    var namemember : [String] = []
    var citymember : [String] = []
    
    
    
    //ピッカービュー
    var pickerview1 : UIPickerView = UIPickerView()
    var pickerview2 : UIPickerView = UIPickerView()
    var pickerview3 : UIPickerView = UIPickerView()
    var pickerview4 : UIPickerView = UIPickerView()
    
    //チェックインした場所の名前、住所
    //@IBOutlet var nameLabel : UILabel!
    //@IBOutlet var addressLabel : UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        
        //現在地取得
        getCurrentPlace()
        
        //この画面で有効にする
        pickerview1.delegate = self
        pickerview1.dataSource = self
        pickerview1.showsSelectionIndicator = true
        
        pickerview2.delegate = self
        pickerview2.dataSource = self
        pickerview2.showsSelectionIndicator = true
        
        pickerview3.delegate = self
        pickerview3.dataSource = self
        pickerview3.showsSelectionIndicator = true
        
        pickerview4.delegate = self
        pickerview4.dataSource = self
        pickerview4.showsSelectionIndicator = true
        
        //ピッカー、完了とキャンセルのツールバー
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(CheckinViewController.done))
        
        //let canselItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(CheckinViewController.cancel))
        
        toolbar.setItems([doneItem], animated: true)
        
        self.stationInput.tag = 1
        self.stationInput.delegate = self
        self.stationInput.inputView = pickerview1
        self.stationInput.inputAccessoryView = toolbar
        pickerview1.tag = 1
        
        self.lineInput.tag = 2
        self.lineInput.delegate = self
        self.lineInput.inputView = pickerview2
        self.lineInput.inputAccessoryView = toolbar
        pickerview2.tag = 2
        
        self.numberOfLineInput.tag = 3
        self.numberOfLineInput.delegate = self
        self.numberOfLineInput.inputView = pickerview3
        self.numberOfLineInput.inputAccessoryView = toolbar
        pickerview3.tag = 3
        
        self.timeInput.tag = 4
        self.timeInput.delegate = self
        self.timeInput.inputView = pickerview4
        self.timeInput.inputAccessoryView = toolbar
        pickerview4.tag = 4
        
        
        //print(searchName)
        //print(searchlocation.latitude)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //print(textField.tag)
        return true
    }
    
    //PickerViewに表示する列数を返す
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //PickerViewに表示する行数を返す
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //print(pickerView.tag)
        
        if pickerView.tag == 1 {
            return stationInputList.count
        }else if pickerView.tag == 2 {
            return lineInputList.count
        }else if pickerView.tag == 3 {
            return numberOfLineInputList.count
        }else{
            return timeinputList.count
        }
        
    }
    
    //Picker Viewに表示する値を返す
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return stationInputList[row]
        }else if pickerView.tag == 2 {
            return lineInputList[row]
        }else if pickerView.tag == 3 {
            return numberOfLineInputList[row]
        }else{
            return timeinputList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            self.stationInput.text = stationInputList[row]
        }else if pickerView.tag == 2{
            self.lineInput.text = lineInputList[row]
        }else if pickerView.tag == 3{
            self.numberOfLineInput.text = numberOfLineInputList[row]
        }else{
            self.timeInput.text = timeinputList[row]
        }
    }

    
    func done() {
        self.stationInput.endEditing(true)
        self.lineInput.endEditing(true)
        self.numberOfLineInput.endEditing(true)
        self.timeInput.endEditing(true)
        
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    //現在のプレイスを取得する 端末の現在地にあるローカル ビジネスなどのプレイスを検出するには、GMSPlacesClient currentPlaceWithCallback: を呼び出す
     func getCurrentPlace(){
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
                switch error.code {
                case -11:
                    self.locationManager = CLLocationManager()
                    self.locationManager.requestAlwaysAuthorization()
                default :
                    print(error.localizedDescription)
                    break
                }
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    //現在地の場所情報
                    print(place.name)
                    print(place.formattedAddress?.components(separatedBy: ",").joined(separator: "\n") ?? String())
                    print(place.coordinate.longitude)
                    print(place.coordinate.latitude)
                    //現在地情報の受け渡し
                    Place.shared.name = place.name
                    Place.shared.location = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    
                    self.stationoptionshow()
                    
                    
                }
            }
        })
    }
    
    //現在地最寄り駅候補
    func stationoptionshow(){
        if let location = Place.shared.location {
            let url = "http://map.simpleapi.net/stationapi?x=\(location.longitude)&y=\(location.latitude)&output=json"
            //print(url)
            
            
            Alamofire.request(url).responseJSON { (response) in
                if let value = response.result.value {
                    let json = JSON(value)
                    //print(json)
                    for stationInfo in json.arrayValue {
                        let station = Station(name: stationInfo["name"].string!)
                        let city = stationInfo["city"].string!

                        self.stationInputList.append("\(station.name)")
                        //self.cityList.append(city)
                        //stationcity = city [0]

                        //print(self.stationInputList)
                        //print(self.cityList)
                    }
                    
                    // ピッカーを更新
                    print("最寄り駅完了")
                    self.reloadInputViews()
                    //self.lineoption()
                }
            }
        }
    }
    
    /*
    //最寄り駅から路線をピッカーの表示
    func lineoption(){
        //CSVファイルの読み込み
        let allStations = loadCSV(filename: "station20170403free")
        
        for station in allStations {
            //カンマで区切る
            let splitStationRow = station.components(separatedBy: ",")
            //print(splitStationRow)
            //print(splitStationRow.count)
            //3回以下なら
            if splitStationRow.count < 3 {
                print("三番目を検索したいので、要素が三個以上必要である。")
                //return
            } else {
                //駅名を抽出
                let name = splitStationRow[2]
                let city = splitStationRow[8]
                
                namemember.append(name)
                citymember.append(city)
                
                //print(namemember)
                //print(citymember)
                
                //print(stationInputList)
                
            }
        
        
        
        
                
                    //stationInputListを最初から最後まで探す
                    for i in 0..<stationInputList.count{
                        //もし、i番目のnameとj番目のstationInputlistが一致したとき
                        if namemember.contains(String(stationInputList[i].characters.dropLast())) {
                            if citymember.contains(cityList[i]){
                                let stationCode = splitStationRow[1]
                                stationCodes.append(stationCode)
                                print(cityList[i])
                                
                                if let code = stationCodes.first {
                                    //駅コードから路線検索
                                    let url = "http://www.ekidata.jp/api/g/\(code).xml"
                                    //print(url)
                                    //Alamofire XML形式　SWXMHash
                                    
                                    Alamofire.request(url).response{ response in
                                        let xml = SWXMLHash.parse(response.data!)
                                        
                                        for stationInfo in xml["ekidata"]["station_g"].all {
                                            //print(stationInfo)
                                            let line = Line(stationCode: stationInfo["station_cd"].element!.text, stationName: stationInfo["station_name"].element!.text, lineCode: stationInfo["line_cd"].element!.text, lineName: stationInfo["line_name"].element!.text)
                                            self.lineInputList.append(line)
                                            print(self.lineInputList)
                                        }
                                        // ピッカーを更新
                                        self.reloadInputViews()
                                    }
                                } else {
                                    print("駅コードから路線が見つかりません")
                                }

                            }
                        }
                    }
            
        }
                
    }
                



    //CSVファイルの読み込み
    func loadCSV(filename: String) -> [String] {
        var csvArray = [String]()
        let csvBundle = Bundle.main.path(forResource: filename, ofType: "csv")
        do {
            let csvData = try String(contentsOfFile: csvBundle!,
                                     encoding: String.Encoding.utf8)
            csvArray = csvData.components(separatedBy:"\n")
        } catch {
            print("読み込みエラー \(filename).csv")
        }
        return csvArray
    }*/
    
    
    
    
    
    //Place Picker を追加する チェックインボタン
    @IBAction func pickPlace(_ sender: UIButton) {
        
        //入力した内容を保存
        Place.shared.station = stationInput.text
        Place.shared.line = lineInput.text
        Place.shared.exit = exitInput.text
        Place.shared.trainNumber = numberOfLineInput.text
        Place.shared.time = timeInput.text
        
        //現在地周辺地図表示
        print(Place.shared)
        let location = Place.shared.location!
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        //let center = CLLocationCoordinate2D(latitude: 35, longitude: 139)
        
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("現在地周辺地図表示\(error.localizedDescription)")
                return
            }
            
            Place.shared.name = place?.name
            //現在地候補から選ぶと名前、住所の表示
            if place != nil {
                //NCMBに書き込み保存
                let object = NCMBObject(className: "Place")
                object?.setObject(Place.shared.name, forKey: "name")
                object?.setObject(Place.shared.station, forKey: "station")
                object?.setObject(Place.shared.line, forKey: "line")
                object?.setObject(Place.shared.exit, forKey: "exit")
                object?.setObject(Place.shared.time, forKey: "time")
                object?.setObject(Place.shared.trainNumber, forKey: "trainNumber")
                object?.setObject(Place.shared.location?.longitude, forKey: "longitude")
                object?.setObject(Place.shared.location?.latitude, forKey: "latitude")
                object?.setObject("", forKey: "memo")
                //ユーザ情報読み込み、保存
                let userId = NCMBUser.current().userName
                object?.setObject(userId, forKey: "userId")

                object?.saveInBackground({ (error) in
                    if error != nil {
                        //保存に失敗
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        //self.nameLabel.text = "場所が選択されていません"
                        //self.addressLabel.text = ""
                    } else {
                        //保存に成功
                        SVProgressHUD.showSuccess(withStatus: "チェックイン完了")
                        //self.nameLabel.text = place.name
                        //self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                            //.joined(separator: "\n")
                        
                        Place.shared.name = nil
                        Place.shared.station = nil
                        Place.shared.line = nil
                        Place.shared.exit = nil
                        Place.shared.time = nil
                        Place.shared.trainNumber = nil
                        Place.shared.location = nil
                        
                        self.stationInput.text = ""
                        self.lineInput.text = ""
                        self.exitInput.text  = ""
                        self.numberOfLineInput.text = ""
                        self.timeInput.text = ""


                        
                        
                        //print(Place.shared.location) nilになっている
                        
                        //指定した秒数後に処理を実行
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
                            SVProgressHUD.dismiss()
                        }
                        
                    }
                })
            
            }
        }
   )}
    
    
    
    
    
    
    
}
