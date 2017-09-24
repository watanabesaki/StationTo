//
//  MainTabBarController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/01.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //バーの背景色
        self.tabBar.barTintColor = UIColor.white

        
        //アイコンカラー
        self.tabBar.tintColor = UIColor(red: 0.3569, green: 0.7529, blue: 0.6078, alpha: 1.0)
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
