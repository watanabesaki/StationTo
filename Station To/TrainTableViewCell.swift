//
//  TrainTableViewCell.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/01.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

class TrainTableViewCell: UITableViewCell {
    
    //路線、出口、車両の変数定義
    @IBOutlet var LineLabel : UILabel!
        
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
