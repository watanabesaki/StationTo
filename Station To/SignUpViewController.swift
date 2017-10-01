//
//  SignUpViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/10/01.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet var userIdTextField : UITextField!
    @IBOutlet var emailTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var confirmTextField : UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //テキストフィールドを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //閉じる
        textField.resignFirstResponder()
        //改行ボタンがきくようになる
        return true
    }
    
    @IBAction func signup(){
        let user = NCMBUser()
        //userid文字数が４文字以下なら登録できない
        if (userIdTextField.text?.characters.count)! < 4{
            print("文字数が足りません")
            return
        }
        
        user.userName = userIdTextField.text!
        user.mailAddress = emailTextField.text!
        
        //パスワード確認用と一致しているか
        if passwordTextField.text == confirmTextField.text {
            user.password = passwordTextField.text!
            
        }else{
            print("パスワードの不一致")
        }
        
        user.signUpInBackground { (error) in
            if error != nil{
                //エラーがあった場合
                print("新規登録error")
            }else{
                //登録が成功した場合
                //スト-リーボードの取得
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootviewcontroller = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                //画面の一番奥の画面に設定する appdeligateのwindowsと同じ意味
                UIApplication.shared.keyWindow?.rootViewController = rootviewcontroller
                
                //ログインしたらuserdefaultに保存 ログイン状態の保持
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.synchronize()
                
                
            }
            
        }
        
    }

    
    

}
