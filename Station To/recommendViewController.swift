//
//  recommendViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/01.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

class recommendViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //TableViewの宣言
    @IBOutlet var recommendTableView : UITableView!
    
    //データを入れる変数
    var recommendmember : [String] = ["東口","西口"]

    
    @IBOutlet var selectedLineNameLabel : UILabel!
    var selectedLineName : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        selectedLineNameLabel.text = selectedLineName
        
        //データソースメソッドをこのファイル内で処理
        recommendTableView.dataSource = self
        //デリゲートメソッドをselfに任せる
        recommendTableView.delegate = self
        
        //カスタムセルの登録
        //xibファイルの取得
        let nib = UINib(nibName: "RecommendTableViewCell", bundle: Bundle.main)
        //取得したファイルを登録
        recommendTableView.register(nib, forCellReuseIdentifier: "recommendCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tableviewに表示するデータの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendmember.count
    }
    
    //tableviewに表示するデータの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //idをつけたcellの取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendCell") as! RecommendTableViewCell
        
        //表示内容を決める
        cell.recommendExitLabel.text = recommendmember [indexPath.row]
        //cell.ExitLabel.text = Line[IndexPath.row]
        //cell.NumberOfTrain.text = Line[IndexPath.row]
        
        //値がないセルには線を表示しない
        tableView.tableFooterView = UIView()
        
        //cellを返す
        return cell
    }


    
}
