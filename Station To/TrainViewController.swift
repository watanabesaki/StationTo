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

    //データを入れる変数
    var Linemember : [String] = ["JR","メトロ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        //cellを返す
        return cell
    }
    
    //セルが押された時のアクション
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移
        //self.performSegue(withIdentifier: "toRecommend", sender: nil)
    }
    
    //何番目のセルが押されたか取得して値渡しする
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //画面取得
        //let trainviewcontroller = segue.destination as! recommendViewController
        
        //今選択されているセルの取得
        //let selectedIndex = LineTableView.indexPathForSelectedRow
        
        //値を取得して値渡し
        //trainviewcontroller.selectedName = [selectedIndex.row][]!
    }

    
}
