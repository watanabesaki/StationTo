//
//  StationViewController.swift
//  Station To
//
//  Created by 渡辺早紀 on 2017/09/24.
//  Copyright © 2017年 Saki Watanabe. All rights reserved.
//

import UIKit

import CoreLocation

import Alamofire
import SwiftyJSON
import SWXMLHash

class StationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //TableViewの宣言
    @IBOutlet var StationTableView : UITableView!
    
    //場所名表示
    @IBOutlet var selectedplaceLabel : UILabel?

    
    //駅配列
    var stations = [Station]()
    var location: CLLocationCoordinate2D!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        StationTableView.dataSource = self
        StationTableView.delegate = self
        //カスタムセル登録
        let nib = UINib(nibName: "StationTableViewCell", bundle: Bundle.main)
        StationTableView.register(nib, forCellReuseIdentifier: "StationCell")
        
        //値がないセルには線を表示しない
        StationTableView.tableFooterView = UIView()
        
        //場所の表示
        selectedplaceLabel?.text = Place.shared.name
        
        //最寄り駅検索
        loadNearByStations()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //画面遷移、次の画面へ選択した駅名を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "toTrain" {
                let indexPath = StationTableView.indexPathForSelectedRow!
                let trainViewController = segue.destination as! TrainViewController
                trainViewController.selectedStation = stations[indexPath.row].name
                //trainViewController.selectedlongitude = stations[indexPath.row].location?.longitude
            }
        }
    }
    //セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    //表示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell") as! StationTableViewCell
        cell.StationLabel.text = stations[indexPath.row].name
        cell.TraveltimeLabel.text = stations[indexPath.row].traveltime
        
        
        
        return cell
    }
    //セルを選択した時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面を消しても元の状態を復元する
        if let id = self.restorationIdentifier {
            if id == "SearchStation" {
                self.performSegue(withIdentifier: "toTrain", sender: nil)
            } else {
                Place.shared.station = stations[indexPath.row].name
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //最寄り駅検索API
    func loadNearByStations() {
        
        if let location = location {
            let url = "http://map.simpleapi.net/stationapi?x=\(location.longitude)&y=\(location.latitude)&output=json"
            
            Alamofire.request(url).responseJSON { (response) in
                if let value = response.result.value {
                    let json = JSON(value)
                    for stationInfo in json.arrayValue {
                        var station = Station(name: stationInfo["name"].string!)
                        station.traveltime = stationInfo["traveltime"].string!
                        self.stations.append(station)
                        
                    }
                    self.StationTableView.reloadData()
                    
                }
            }
        } else {
            if let location = Place.shared.location {
                let url = "http://map.simpleapi.net/stationapi?x=\(location.longitude)&y=\(location.latitude)&output=json"
                
                Alamofire.request(url).responseJSON { (response) in
                    if let value = response.result.value {
                        let json = JSON(value)
                        for stationInfo in json.arrayValue {
                            var station = Station(name: stationInfo["name"].string!)
                            station.traveltime = stationInfo["traveltime"].string!
                            self.stations.append(station)
                        }
                        self.StationTableView.reloadData()
                    }
                }
            }
        }
        
    }

    

}
