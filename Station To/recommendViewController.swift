//
//  recommendViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/01.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

import NCMB

class recommendViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //TableViewの宣言
    @IBOutlet var recommendTableView : UITableView!
    
    var selectedplace : String!
    
    //データを入れる変数
    //出口
    var recommendmember : [String] = []
    //電車の号車
    var recommendtrainmember : [String] = []
    //時間
    var recommendtimemember : [String] = []
    
    //投稿データがないときに表示
    @IBOutlet var nodateLabel : UILabel!

    
    @IBOutlet var selectedLineNameLabel : UILabel!
    var selectedLineName : String = ""
    
    @IBOutlet var selectedStationNameLabel : UILabel!
    var selectedStationName : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showroot()

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
    
    
    //投稿NCMBデータの取得、表示
    func showroot(){
        let query = NCMBQuery(className: "Place")
        query?.whereKey("name", equalTo: selectedplace)
        query?.whereKey("station", equalTo: selectedStationName)
        query?.whereKey("line", equalTo: selectedLineName)
        
        print(query)
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("投稿データ取得error")
            } else {
                //履歴の読み込みが可能
                let places = result as! [NCMBObject]
                print(places)
                
                if places != nil {
                    //for文を逆から回して最新の履歴を上にする
                    for places in places.reversed() {
                        let exit = places.object(forKey: "exit") as! String
                        let trainnumber = places.object(forKey: "trainNumber") as! String
                        let time = places.object(forKey: "time") as! String
                        
                        let trainnumberNew = "\(trainnumber)号車"
                        let timeNew = "駅から\(time)分"
                        
                        
                        self.recommendmember.append(exit)
                        self.recommendtrainmember.append(trainnumberNew)
                        self.recommendtimemember.append(timeNew)
                        
                    }
                    
                    self.recommendTableView.reloadData()
                    
                    
                }else{
                    print("投稿されたデータがありません")
                    self.nodateLabel.text = "投稿されたデータががありません"
                    
                }
                
                
                //履歴があるかないか
                /*if place != nil{
                 print("チェックイン履歴がありません")
                 self.historyLabel.text = "チェックイン履歴がありません"
                 }else{
                 for place in place {
                 let name = place.object(forKey: "name") as! String
                 let date = place.object(forKey: "createDate") as! String
                 
                 self.namemember.append(name)
                 self.datemember.append(date)
                 
                 }
                 print(self.namemember)
                 
                 self.historyTableView.reloadData()
                 }*/
                
            }
        })
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
