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

class CheckinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    var locationManager: CLLocationManager!
    
    //googleplace現在地の取得
    var placesClient: GMSPlacesClient!
    
    //検索した場所の名前
    //var searchName : String!
    //var searchlocation : CLLocationCoordinate2D!

    
    //駅名入力
    @IBOutlet var stationInput : UITextField!
    let stationInputList = ["","日比谷","新橋","内幸町"]
    
    //路線入力
    @IBOutlet var lineInput : UITextField!
    let lineInputList = ["","JR山手線","JR京浜東北線"]
    
    //出口入力
    @IBOutlet var exitInput : UITextField!
    
    // 何両目
    @IBOutlet var numberOfLineInput : UITextField!
    let numberOfLineInputList = ["","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    
    //何分
    @IBOutlet var timeInput : UITextField!
    let timeinputList = ["","3","5","10","15","20","25","30","40","50","60"]
    
    
    
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
                    
                }
            }
        })
    }
    
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
            
            //現在地候補から選ぶと名前、住所の表示
            if let place = place {
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
