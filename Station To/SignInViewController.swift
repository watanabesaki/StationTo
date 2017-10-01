//
//  SignInViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/10/01.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

import NCMB

class SignInViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var userIdTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        passwordTextField.delegate = self


        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //入力後しまう
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func signIn(){
        
        //何も入力しないとクラッシュしてしまう 入力しないとエラー
        if (userIdTextField.text?.characters.count)! > 0 && (passwordTextField.text?.characters.count)! > 0  {
            NCMBUser.logInWithUsername(inBackground: self.userIdTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error != nil{
                    print("ログインエラー")
                }else{
                    //ログイン成功
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
    
    @IBAction func forgetpassword(){
        
    }


}
