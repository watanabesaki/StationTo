//
//  StationTableViewCell.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/24.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    //駅名、時間の変数定義
    @IBOutlet var StationLabel : UILabel!
    @IBOutlet var TraveltimeLabel : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        StationLabel.adjustsFontSizeToFitWidth = true
        TraveltimeLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
