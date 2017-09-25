//
//  TrainViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/08/27.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import SWXMLHash

class TrainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    //TableViewの宣言
    @IBOutlet var LineTableView : UITableView!
    
    //選択した駅名変数定義
    @IBOutlet var selectedStationLabel : UILabel!
    var selectedStation : String!
    
    //駅コード変数
    var stationCodes = [String]()

    //路線データを入れる変数
    var Linemember : [Line] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedStationLabel.text = selectedStation

        //データソースメソッドをこのファイル内で処理
        LineTableView.dataSource = self
        //デリゲートメソッドをselfに任せる
        LineTableView.delegate = self
        
        //値がないセルには線を表示しない
        LineTableView.tableFooterView = UIView()
        
        //文字数に応じてサイズ調節
        selectedStationLabel.adjustsFontSizeToFitWidth = true
    
        //カスタムセルの登録
            //xibファイルの取得
            let nib = UINib(nibName: "TrainTableViewCell", bundle: Bundle.main)
            //取得したファイルを登録
            LineTableView.register(nib, forCellReuseIdentifier: "LineCell")
        
        print(Linemember)
        
        //トップに戻るボタンを作成
        /*
        let leftButton = UIBarButtonItem(title: "チェックイン", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TrainViewController.goTop))
        self.navigationItem.leftBarButtonItem = leftButton
        */
        
        loadLines()
        
        
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
        cell.LineLabel.text = Linemember [indexPath.row].lineName
        
        //cellを返す
        return cell
    }
    
    //セルが押された時のアクション
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let id = self.restorationIdentifier {
            if id == "SearchLine" {
                //画面遷移
                self.performSegue(withIdentifier:"toRecommend", sender: nil)
            } else {
                Place.shared.line = Linemember[indexPath.row].lineName
                self.navigationController?.popViewController(animated: true)
            }
        }
        //戻った時の選択状態解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //何番目のセルが押されたか取得して値渡しする
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //画面取得
        let trainviewcontroller = segue.destination as! recommendViewController
        
        //今選択されているセルの取得
        let selectedIndex = LineTableView.indexPathForSelectedRow!
        
        //路線の値を取得して値渡し
        trainviewcontroller.selectedLineName = Linemember[selectedIndex.row].lineName
        
        //駅名の値渡し
        trainviewcontroller.selectedStationName = selectedStation
        
    }
    
    /*
    //戻るボタン押下時の呼び出しメソッド
    func goTop() {
        
        //チェックイン画面に戻る。
        self.navigationController?.popViewController(animated: true)
    }
    */

    //路線検索関数
    func loadLines() {
        //CSVファイルの読み込み
        let allStations = loadCSV(filename: "station20170403free")
        
        for station in allStations {
            //カンマで区切る
            let splitStationRow = station.components(separatedBy: ",")
            
            print(splitStationRow.count)
            
            //3回以下なら
            if splitStationRow.count < 3 {
                print("駅名から駅コード検索失敗")
                //return
            } else {
                //駅名を抽出
                let selectedstation = splitStationRow[2]
                //選択した駅名と等しい駅名があったら
                if let selectedStation = selectedStation {
                    if selectedStation.contains(String(selectedStation.characters.dropLast())) == true {
                        // 駅コード抽出、配列に追加
                        let stationCode = splitStationRow[1]
                        stationCodes.append(stationCode)
                    }
                } else {
                    //
                    if let station = Place.shared.station {
                        if selectedStation.contains(String(station.characters.dropLast())) == true {
                            // 駅コード抽出、配列に追加
                            let stationCode = splitStationRow[1]
                            print(stationCode)
                            stationCodes.append(stationCode)
                        }
                    }
                }
            }
        }
        
        if let code = stationCodes.first {
            //駅コードから路線検索
            let url = "http://www.ekidata.jp/api/g/\(code).xml"
            //Alamofire XML形式　SWXMHash
            Alamofire.request(url).response{ response in
                let xml = SWXMLHash.parse(response.data!)
                
                for stationInfo in xml["ekidata"]["station_g"].all {
                    print(stationInfo)
                    let line = Line(stationCode: stationInfo["station_cd"].element!.text, stationName: stationInfo["station_name"].element!.text, lineCode: stationInfo["line_cd"].element!.text, lineName: stationInfo["line_name"].element!.text)
                    self.Linemember.append(line)
                }
                self.LineTableView.reloadData()
            }
        } else {
            print("駅コードから路線が見つかりません")
        }
        
    }
    

    //CSVファイルの読み込み
    func loadCSV(filename: String) -> [String] {
        var csvArray = [String]()
        let csvBundle = Bundle.main.path(forResource: filename, ofType: "csv")
        do {
            let csvData = try String(contentsOfFile: csvBundle!,
                                     encoding: String.Encoding.utf8)
            csvArray = csvData.components(separatedBy:"\n")
        } catch {
            print("読み込みエラー \(filename).csv")
        }
        return csvArray
    }
    

}
