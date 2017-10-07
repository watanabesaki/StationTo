//
//  DetailViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/25.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD


class DetailViewController: UIViewController {
    
    var places : [NCMBObject] = []
    
    var detailobjectid : String!
    
    @IBOutlet var detailnameLabel : UILabel!
    var detailname : String!
    
    @IBOutlet var detaildateLabel : UILabel!
    var detaildate : String = ""
    
    @IBOutlet var detailstationLabel : UILabel!
    var detailstation : String = ""
    
    @IBOutlet var detaillineLabel : UILabel!
    var detailline :String = ""
    
    @IBOutlet var detailexitLabel : UILabel!
    var detailexit : String = ""
    
    @IBOutlet var detailnumberoftrainLabel : UILabel!
    var detailnumberoftrain : String = ""
    
    @IBOutlet var detailtimeLabel : UILabel!
    var detaitime : String = ""
    
    @IBOutlet var detailmemoTextView : UITextView!
    var detailmemo : String = ""

    

    override func viewDidLoad() {
        super.viewDidLoad()

        showdetail()
        
        detailnameLabel.text = detailname
        detaildateLabel.text = "訪問日：\(detaildate)"
        detailstationLabel.text = "駅名：\(detailstation)"
        detailexitLabel.text = "出口：\(detailexit)"
        detaillineLabel.text = "路線：\(detailline)"
        detailnumberoftrainLabel.text = "出口に近い車両：\(detailnumberoftrain)号車"
        detailtimeLabel.text = "駅から：\(detaitime)分"
        detailmemoTextView.text = detailmemo
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "toEdit" {
                let editmemoViewController = segue.destination as! editmemoViewController
                editmemoViewController.editobjectid = detailobjectid
                editmemoViewController.memo = detailmemo
            }
        }
    }

    

    
    
    //チェックイン履歴の詳細表示NCMBデータの取得
    func showdetail(){
        let query = NCMBQuery(className: "Place")
        query?.whereKey("objectId", equalTo: detailobjectid)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("チェックイン履歴詳細表示エラー")
            } else {
                let places = result as! [NCMBObject]
                
                if  places != nil{
                    
                        let station = places.first?.object(forKey: "station") as! String
                        let exit = places.first?.object(forKey: "exit") as! String
                        let line = places.first?.object(forKey: "line") as! String
                        let trainnumber = places.first?.object(forKey: "trainNumber") as! String
                        let time = places.first?.object(forKey: "time") as! String
                        let memo = places.first?.object(forKey: "memo") as! String

                    

                        self.detailstation = station
                        self.detailexit = exit
                        self.detailline = line
                        self.detailnumberoftrain = trainnumber
                        self.detaitime = time
                        self.detailmemo = memo
                            
                        //print(self.detatilstation)
                    
                    self.viewDidLoad()

                }else{
                    print("チェックイン履歴はありません")
                }
                
            }
        })
    }

/*
    //メモの更新
    @IBAction func memoupdate() {
        //NCMBに書き込み保存
        let object = NCMBQuery(className: "Place")
        //query?.whereKey("name",equalTo: "")
        
        object?.findObjectsInBackground({ (result,error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                print("保存する場所エラー")
            } else {
                let memo = result as! [NCMBObject]
                let text = memo.first
                text?.setObject("", forKey: "memo")
                //self.detailnameLabel.text =
                /*
                object?.saveInBackground ({ (error) in
                        if error != nil {
                            //保存に失敗
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                            print("保存失敗")
                        } else {
                            //保存に成功
                            SVProgressHUD.showSuccess(withStatus: "更新完了")
                            
                            //指定した秒数後に処理を実行
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
                                SVProgressHUD.dismiss()
                            }
                            
                        }
                    })
                
            }
            }
        )}*/

}*/
    
    
    @IBAction func editmemo(){
        let alertContoller = UIAlertController(title: "編集", message: "選択してください", preferredStyle: .actionSheet)
        //チェックイン登録情報編集ボタン
        let editAction = UIAlertAction(title: "チェックイン情報の編集", style: .default) { (action) in
            //チェックイン登録情報の編集　メモの追加
            
            
        }
        
        //キャンセルボタン
        let canselAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertContoller.dismiss(animated: true, completion: nil)
        }
        
        alertContoller.addAction(canselAction)
        alertContoller.addAction(editAction)
        self.present(alertContoller, animated: true, completion: nil)
    }
    
    
    
}
