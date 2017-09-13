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
    //出口
    var recommendmember : [String] = ["東口","東口"]
    //電車の号車
    var recommendtrainmember : [String] = ["３号車","５号車"]
    //時間
    var recommendtimemember : [String] = ["徒歩５分","徒歩５分"]

    
    @IBOutlet var selectedLineNameLabel : UILabel!
    var selectedLineName : String = ""
    
    @IBOutlet var selectedStationNameLabel : UILabel!
    var selectedStationName : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        //路線表示
        selectedLineNameLabel.text = selectedLineName
        
        //駅名表示
        selectedStationNameLabel.text = selectedStationName
        
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
        
        cell.recommendtrainLabel.text = recommendtrainmember[indexPath.row]
        
        cell.recommendtimeLabel.text = recommendtimemember [indexPath.row]
        
        
        //値がないセルには線を表示しない
        tableView.tableFooterView = UIView()
        
        //cellを返す
        return cell
    }
    
    //戻るボタン押下時の呼び出しメソッド
    func goTop() {
        
        //チェックイン画面に戻る。
        self.navigationController?.popViewController(animated: true)
    }



    
}
