//
//  CheckinViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/08/31.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

import GooglePlaces


class CheckinViewController: UIViewController {
    
   var placesClient = GMSPlacesClient()
    
    //現在地の名前
    @IBOutlet var nameLabel : UILabel!
    
    //現在地の住所
    @IBOutlet var addressLabel : UILabel!


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
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ",")
                        .joined(separator: "\n")
                    print(place.name)
                    print(place.formattedAddress?.components(separatedBy: ",").joined(separator: "\n") ?? String())
                }
            }
        })
    }

    
    
}
