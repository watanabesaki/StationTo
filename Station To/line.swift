//
//  line.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/24.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import Foundation
import UIKit

struct Line {
    
    var lineCode: String
    var lineName: String
    var stationCode: String
    var stationName: String
    
    init(stationCode: String, stationName: String, lineCode: String, lineName: String) {
        self.lineCode = lineCode
        self.lineName = lineName
        self.stationCode = stationCode
        self.stationName = stationName
    }
    
}

