//
//  TrainViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/08/27.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

class TrainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    //TableViewの宣言
    @IBOutlet var LineTableView : UITableView!
    
    //選択した駅名変数定義
    @IBOutlet var selectedStationLabel : UILabel!
    var selectedStation : String = "新橋駅"

    //データを入れる変数
    var Linemember : [String] = ["JR山手線内回り","JR山手線外回り","JR京浜東北線上り","JR京浜東北線下り"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedStationLabel.text = selectedStation

        //データソースメソッドをこのファイル内で処理
        LineTableView.dataSource = self
        //デリゲートメソッドをselfに任せる
        LineTableView.delegate = self
        
        //カスタムセルの登録
            //xibファイルの取得
            let nib = UINib(nibName: "TrainTableViewCell", bundle: Bundle.main)
            //取得したファイルを登録
            LineTableView.register(nib, forCellReuseIdentifier: "LineCell")
        
        print(Linemember)
        
        //トップに戻るボタンを作成
        let leftButton = UIBarButtonItem(title: "チェックイン", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TrainViewController.goTop))
        self.navigationItem.leftBarButtonItem = leftButton
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    //tableviewに表示するデータの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Linemember.count
    }
    
    //tableviewに表示するデータの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //idをつけたcellの取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineCell") as! TrainTableViewCell
        
        //表示内容を決める
        cell.LineLabel.text = Linemember [indexPath.row]
        //cell.ExitLabel.text = Line[IndexPath.row]
        //cell.NumberOfTrain.text = Line[IndexPath.row]
        
        //値がないセルには線を表示しない
        tableView.tableFooterView = UIView()
        
        //cellを返す
        return cell
    }
    
    //セルが押された時のアクション
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移
        self.performSegue(withIdentifier:"toRecommend", sender: nil)
        
        //戻った時の選択状態解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //何番目のセルが押されたか取得して値渡しする
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //画面取得
        let trainviewcontroller = segue.destination as! recommendViewController
        //let trainviewcontroller2 = segue.destination as! recommendViewController
        
        
        //今選択されているセルの取得
        let selectedIndex = LineTableView.indexPathForSelectedRow!
        
        //値を取得して値渡し
        trainviewcontroller.selectedLineName = Linemember[selectedIndex.row]
        //駅名の値渡し
        trainviewcontroller.selectedStationName = selectedStation
        
    }
    
    //戻るボタン押下時の呼び出しメソッド
    func goTop() {
        
        //チェックイン画面に戻る。
        self.navigationController?.popViewController(animated: true)
    }

    
}
