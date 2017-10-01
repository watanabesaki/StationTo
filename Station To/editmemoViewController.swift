//
//  editmemoViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/10/01.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

import NCMB

class editmemoViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet var memoeditTextView : UITextView!
    var memo : String!
    
    var editobjectid : String!

    override func viewDidLoad() {
        super.viewDidLoad()

        memoeditTextView.delegate = self
        
        memoeditTextView.text = memo
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    
    //メモ入力完了
    @IBAction func save(){
        
        //データの取得
        let query = NCMBQuery(className: "Place")
        query?.whereKey("objectId", equalTo: editobjectid)
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("データ取得エラー")
            }else{
                //履歴の読み込みが可能
                let places = result as! [NCMBObject]
                let textObjects = places.first
                textObjects?.setObject(self.memoeditTextView.text, forKey: "memo")
                textObjects?.saveInBackground({ (error) in
                    if error != nil{
                        print("データ更新エラー")
                    }else{
                        print("更新完了")
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        })
        
    }



    
}
