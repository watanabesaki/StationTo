//
//  station.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/24.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct Station {
    
    var name: String
    var traveltime: String?
    var location: CLLocationCoordinate2D?
    var city : String?
    
    init(name: String) {
        self.name = name
        
    }
    
}

