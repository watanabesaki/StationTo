//
//  MypageViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/08/31.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

import NCMB

class MypageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var historyLabel : UILabel!
    
    var namemember : [String] = []
    var datemember : [String] = []
    var places : [NCMBObject] = []
    
    //TableViewの宣言
    @IBOutlet var historyTableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //履歴表示
        showhistory()
        
        //データソースメソッドをこのファイル内で処理
        historyTableView.dataSource = self
        //デリゲートメソッドをselfに任せる
        historyTableView.delegate = self
        
        //値がないセルには線を表示しない
        historyTableView.tableFooterView = UIView()
        
        //カスタムセルの登録
        //xibファイルの取得
        let nib = UINib(nibName: "MypageTableViewCell", bundle: Bundle.main)
        //取得したファイルを登録
        historyTableView.register(nib, forCellReuseIdentifier: "historyCell")
        historyTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //チェックイン履歴の表示NCMBデータの取得
    func showhistory(){
        let query = NCMBQuery(className: "Place")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("マイページ履歴error")
            } else {
                self.places = result as! [NCMBObject]
                print(self.places.count)
                
                if self.places != nil{
                    print("チェックイン履歴がありません")
                    self.historyLabel.text = "チェックイン履歴がありません"
                }else{
                    for place in self.places {
                        let name = place.object(forKey: "name") as! String
                        let date = place.object(forKey: "createDate") as! String
                        
                        self.namemember.append(name)
                        self.datemember.append(date)
                        
                    }
                    print(self.namemember)
                    print(self.datemember)
                    
                    self.historyTableView.reloadData()
                }
                
            }
        })
    }

    //tableviewに表示するデータの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    //tableviewに表示するデータの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //idをつけたcellの取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! MypageTableViewCell
        
        //表示内容を決める
        cell.historyplaceLabel.text = self.namemember[indexPath.row]
        cell.historytimeLabel.text = self.datemember[indexPath.row]
        
        //cellを返す
        return cell
    }
    
    //セルが押された時のアクション
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //画面遷移
        self.performSegue(withIdentifier:"toDetail", sender: nil)
        
        //戻った時の選択状態解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
   
}
