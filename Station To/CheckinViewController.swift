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

class CheckinViewController: UIViewController {
    
   var placesClient = GMSPlacesClient()
    
    //現在地の名前
    @IBOutlet var nameLabel : UILabel!
    
    //現在地の住所
    @IBOutlet var addressLabel : UILabel!
    
    @IBOutlet var herenameLabel : UILabel!
    @IBOutlet var hereaddressLabel : UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        placesClient = GMSPlacesClient.shared()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
                self.nameLabel.text = "No place selected"
                self.addressLabel.text = ""
            }
        })
    }

    
    
}
