//
//  RecommendTableViewCell.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/12.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

class RecommendTableViewCell: UITableViewCell {
    
    @IBOutlet var recommendExitLabel : UILabel!
    
    @IBOutlet var recommendtrainLabel : UILabel!
    
    @IBOutlet var recommendtimeLabel : UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
