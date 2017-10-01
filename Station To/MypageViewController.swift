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
    var places = [NCMBObject]()
    
    var objectidmember : [String] = []
    
    //useridの表示
    @IBOutlet var useridLabel : UILabel?
    
    //訪問数、ポイント数
    @IBOutlet var visitnumberLabel : UILabel!
    @IBOutlet var pointnumberLabel : UILabel!
    
    
    //TableViewの宣言
    @IBOutlet var historyTableView : UITableView!
    
    //下にスワイプすると更新
    var refreshControl:UIRefreshControl!

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
        
        //下にスワイプすると履歴の更新
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "更新中...") // Loading中に表示する文字を決める
        self.refreshControl.addTarget(self, action: "pullToRefresh", for:.valueChanged)
        self.historyTableView.addSubview(refreshControl)
        //refreshControl = refresh
        
        //ユーザの情報を読み込む
        let userId = NCMBUser.current().userName
        useridLabel?.text = userId
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //画面遷移、次の画面へ選択した場所名を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "toDetail" {
                let indexPath = historyTableView.indexPathForSelectedRow!
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.detailname = namemember[indexPath.row]
                detailViewController.detaildate = datemember[indexPath.row]
                detailViewController.detailobjectid = objectidmember[indexPath.row]

            }
        }
    }

    
    
    //チェックイン履歴の表示NCMBデータの取得
    func showhistory(){
        let query = NCMBQuery(className: "Place")
        // ユーザ情報の読み出し
        let userId = NCMBUser.current().userName
        query?.whereKey("userId", equalTo: userId)
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("マイページ履歴error")
            } else {
                //履歴の読み込みが可能
                let places = result as! [NCMBObject]
                //print(places)
                
                if places != nil {
                    //for文を逆から回して最新の履歴を上にする
                    for places in places.reversed() {
                        let name = places.object(forKey: "name") as! String
                        let date = places.object(forKey: "createDate") as! String
                        let datenew = date.substring(to: date.index(date.startIndex, offsetBy: 10))
                        
                        let objectid = places.object(forKey: "objectId") as! String
                        
                        self.namemember.append(name)
                        self.datemember.append(datenew)
                        self.objectidmember.append(objectid)
                        
                    }
                    
                    self.historyTableView.reloadData()
                    self.visitnumberLabel.text = String(self.namemember.count)

                }else{
                    print("チェックイン履歴がありません")
                    self.historyLabel.text = "チェックイン履歴がありません"

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
        return namemember.count
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
    
    // 下にスワイプしたら更新
    func pullToRefresh(){
        showhistory()//データを取る関数を呼び出す
        refreshControl.endRefreshing() // データが取れたら更新を終える（くるくる回るViewを消去）
        self.historyTableView.reloadData() // tableView自身を再読み込み
        print("リロード完了")
        
    }
    
    
    @IBAction func showmenu(){
        let alertContoller = UIAlertController(title: "メニュー", message: "選択してください", preferredStyle: .actionSheet)
        //ログアウトボタン
        let signoutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground({ (error) in
                if error != nil{
                    //ログアウトのエラー
                    print("ログアウトエラー")
                }else{
                    //ログインアウト成功
                    //登録が成功した場合
                    //スト-リーボードの取得
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootviewcontroller = storyboard.instantiateViewController(withIdentifier: "RootnavigationController")
                    //画面の一番奥の画面に設定する appdeligateのwindowsと同じ意味
                    UIApplication.shared.keyWindow?.rootViewController = rootviewcontroller
                    
                    //ログインアウトしたらuserdefaultに保存
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                    
                }
            })
        }
        //退会ボタン
        let deleteaction = UIAlertAction(title: "退会", style: .default) { (action) in
            //現在ログインしているアカウント取得
            let user = NCMBUser.current()
            user?.deleteInBackground({ (error) in
                if error != nil{
                    print("ログアウトエラー")
                }else{
                    //ログインアウト成功
                    //登録が成功した場合
                    //スト-リーボードの取得
                    let storyboard = UIStoryboard(name: "signin", bundle: Bundle.main)
                    let rootviewcontroller = storyboard.instantiateViewController(withIdentifier: "RootnavigationController")
                    //画面の一番奥の画面に設定する appdeligateのwindowsと同じ意味
                    UIApplication.shared.keyWindow?.rootViewController = rootviewcontroller
                    
                    //ログインアウトしたらuserdefaultに保存
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            })
        }
        
        //キャンセルボタン
        let canselAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertContoller.dismiss(animated: true, completion: nil)
        }
        
        alertContoller.addAction(canselAction)
        alertContoller.addAction(signoutAction)
        alertContoller.addAction(deleteaction)
        self.present(alertContoller, animated: true, completion: nil)
    }

    

    
   
}
