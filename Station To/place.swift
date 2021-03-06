//
//  place.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/24.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct Place {
    
    let titles = ["場所", "最寄り駅", "路線", "最寄り出口(オプション)", "方面(オプション)", "出口付近車両(オプション)"]
    
    static var shared = Place()
    
    var name: String?
    var station: String?
    var line: String?
    var direction: String?
    var exit: String?
    var trainNumber: String?
    var location: CLLocationCoordinate2D?
    var time : String!
    
}

