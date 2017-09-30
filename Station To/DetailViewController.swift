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
    
    @IBOutlet var detailnameLabel : UILabel!
    var detatilname : String!
    
    @IBOutlet var detaildateLabel : UILabel!
    var detatildate : String = ""
    
    @IBOutlet var detailstationLabel : UILabel!
    var detatilstation : String = ""
    
    @IBOutlet var detaillineLabel : UILabel!
    var detatilline :String = ""
    
    @IBOutlet var detailexitLabel : UILabel!
    var detatilexit : String = ""
    
    @IBOutlet var detailnumberoftrainLabel : UILabel!
    var detatilnumberoftrain : String = ""
    
    @IBOutlet var detailtimeLabel : UILabel!
    var detatitime : String = ""
    
    @IBOutlet var detailmemoTextView : UITextView!

    

    override func viewDidLoad() {
        super.viewDidLoad()

        showdetail()
        
        detailnameLabel.text = detatilname
        detaildateLabel.text = detatildate
        detailstationLabel.text = detatilstation
        detailexitLabel.text = detatilexit
        detaillineLabel.text = detatilline
        detailnumberoftrainLabel.text = detatilnumberoftrain
        detailtimeLabel.text = detatitime
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadInputViews()
    }
    
    
    //チェックイン履歴の表示NCMBデータの取得
    func showdetail(){
        let query = NCMBQuery(className: "Place")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("チェックイン履歴詳細表示エラー")
            } else {
                self.places = result as! [NCMBObject]
                print(self.places.count)
                
                if self.places != nil{
                    print("チェックイン履歴はありません")
                    
                }else{
                    for place in self.places {
                        let name = place.object(forKey: "name") as! String
                        let date = place.object(forKey: "createDate") as! String
                        let station = place.object(forKey: "station") as! String
                        let exit = place.object(forKey: "exit") as! String
                        let line = place.object(forKey: "line") as! String
                        let trainnumber = place.object(forKey: "trainnumber") as! String
                        let time = place.object(forKey: "time") as! String
                        

                        self.detatildate = date
                        self.detatilstation = station
                        self.detatilexit = exit
                        self.detatilline = line
                        self.detatilnumberoftrain = trainnumber
                        self.detatitime = time
                        
                    }

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
}
