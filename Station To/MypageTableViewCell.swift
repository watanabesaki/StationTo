//
//  MypageTableViewCell.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/25.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

class MypageTableViewCell: UITableViewCell {
    
    @IBOutlet var historyplaceLabel :UILabel!
    @IBOutlet var historytimeLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //文字数に応じてサイズ調節
        historyplaceLabel.adjustsFontSizeToFitWidth = true
        //文字数に応じてサイズ調節
        historytimeLabel.adjustsFontSizeToFitWidth = true
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
