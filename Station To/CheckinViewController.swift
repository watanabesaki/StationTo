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

class CheckinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        
        
        
    //googleplace現在地の取得
    var placesClient = GMSPlacesClient()
        
    //チェックインした場所の名前、住所
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var addressLabel : UILabel!
        
    //現在地の名前、住所
    @IBOutlet var herenameLabel : UILabel!
    @IBOutlet var hereaddressLabel : UILabel!
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        placesClient = GMSPlacesClient.shared()
            
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
        
        let canselItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(CheckinViewController.cancel))
        
        toolbar.setItems([canselItem, doneItem], animated: true)
            
        self.stationInput.inputView = pickerview1
        self.stationInput.inputAccessoryView = toolbar
        pickerview1.tag = 1
        
        self.lineInput.inputView = pickerview2
        self.lineInput.inputAccessoryView = toolbar
        pickerview2.tag = 2


        self.numberOfLineInput.inputView = pickerview3
        self.numberOfLineInput.inputAccessoryView = toolbar
        pickerview3.tag = 3


        self.timeInput.inputView = pickerview4
        self.timeInput.inputAccessoryView = toolbar
        pickerview4.tag = 4

        
        

        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            
    }
        
    //PickerViewに表示する列数を返す
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //PickerViewに表示する行数を返す
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerview1.tag == 1{
            return stationInputList.count
        }else if pickerview2.tag == 2{
            return lineInputList.count
        }else if pickerview3.tag == 3{
            return numberOfLineInputList.count
        }else{
            return timeinputList.count
        }
        
    }
    
    //Picker Viewに表示する値を返す
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerview1.tag == 1{
            return stationInputList[row]
        }else if pickerview2.tag == 2{
            return lineInputList[row]
        }else if pickerview3.tag == 3{
            return numberOfLineInputList[row]
        }else{
            return timeinputList[row]
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerview1.tag == 1{
            self.stationInput.text = stationInputList[row]
        }else if pickerview2.tag == 2{
            self.lineInput.text = lineInputList[row]
        }else if pickerview2.tag == 2{
            self.numberOfLineInput.text = numberOfLineInputList[row]
        }else{
            self.timeInput.text = timeinputList[row]
        }
    }
        
    func cancel() {
        if pickerview1.tag == 1{
            self.stationInput.text = ""
            self.stationInput.endEditing(true)
        }else if pickerview2.tag == 2{
            self.lineInput.text = ""
            self.lineInput.endEditing(true)

        }else if pickerview3.tag == 3{
            self.numberOfLineInput.text = ""
            self.numberOfLineInput.endEditing(true)

        }else{
            self.timeInput.text = ""
            self.timeInput.endEditing(true)
        }
        
    }
        
    func done() {
        
        if pickerview1.tag == 1 {
            self.stationInput.endEditing(true)
        }else if pickerview2.tag == 2{
            self.lineInput.endEditing(true)
        }else if pickerview3.tag == 3{
            self.numberOfLineInput.endEditing(true)

        }else{
            self.timeInput.endEditing(true)

        }
        

    }
        
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
        
        
        //現在のプレイスを取得する 端末の現在地にあるローカル ビジネスなどのプレイスを検出するには、GMSPlacesClient currentPlaceWithCallback: を呼び出す
        @IBAction func getCurrentPlace(_ sender: UIButton) {
            
            placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
                if let error = error {
                    print("Pick Place error: \(error.localizedDescription)")
                    return
                }
                
                self.herenameLabel.text = "No current place"
                self.hereaddressLabel.text = ""
                
                if let placeLikelihoodList = placeLikelihoodList {
                    let place = placeLikelihoodList.likelihoods.first?.place
                    if let place = place {
                        self.herenameLabel.text = place.name
                        self.hereaddressLabel.text = place.formattedAddress?.components(separatedBy: ",")
                            .joined(separator: "\n")
                        print(place.name)
                        print(place.formattedAddress?.components(separatedBy: ",").joined(separator: "\n") ?? String())
                    }
                }
            })
        }
        
        //Place Picker を追加する
        @IBAction func pickPlace(_ sender: UIButton) {
            
            //現在地の緯度経度
            let center = CLLocationCoordinate2D(latitude: 35.6709056, longitude: 139.7577372)
            
            let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
            let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
            let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            let config = GMSPlacePickerConfig(viewport: viewport)
            let placePicker = GMSPlacePicker(config: config)
            
            placePicker.pickPlace(callback: {(place, error) -> Void in
                if let error = error {
                    print("Pick Place error: \(error.localizedDescription)")
                    return
                }
                
                //現在地候補から選ぶと名前、住所の表示
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                } else {
                    self.nameLabel.text = "場所が選択されていません"
                    self.addressLabel.text = ""
                }
            })
        }
        
        
        
}
