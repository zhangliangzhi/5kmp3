//
//  ViewController.swift
//  xx5kmp3
//
//  Created by ZhangLiangZhi on 2017/1/25.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

var arrGlobalSet:[CurGlobalSet] = []
var arrYbSec:[YbTime] = []
var nowGlobalSet:CurGlobalSet?


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var labelStart: UILabel!
    @IBOutlet weak var labelEnd: UILabel!
    @IBOutlet weak var sliderTime: UISlider!
    
    var arrPlayer = [AVAudioPlayer]()
    
    var timer:Timer!
    var curTime:Int = 0
    var curRow:Int = -1
    var isPlaying:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        firstOpenAPP()
        
        for i in 0..<gName.count {
            initAudio(row: i)
        }

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tickDown), userInfo: nil, repeats: true)
    }
    
    func tickDown() -> Void {
        print("tick down")
        curTime = curTime + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = gName[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initAudio(row:Int) {
        let name = gName[row]
        
        var player = AVAudioPlayer()
        let path = Bundle.main.path(forResource: name, ofType: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: URL(string: path)!)
            player.prepareToPlay()
            player.numberOfLoops = -1
//            player.play()
            arrPlayer.append(player)
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if curRow == indexPath.row {
            
        }else {
            curRow = indexPath.row
            for i in 0..<gName.count {
                arrPlayer[i].stop()
            }
        }
        
        
        if isPlaying {
            //  暂停
            isPlaying = false
            curTime = 0
            appDelegate.saveContext()
        }else {
            // 播放
            isPlaying = true
            let player = arrPlayer[indexPath.row]
            player.play()
        }
        
        
        

    }
    
    func playPause() -> Void {
        
    }

    // 获取数据
    func getCoreData() -> Void {
        arrGlobalSet = []
        do {
            arrGlobalSet = try context.fetch(CurGlobalSet.fetchRequest())
        }catch {
            print("coreData CurGlobalSet error")
        }
        
        do {
            arrYbSec = try context.fetch(YbTime.fetchRequest())
            print(arrYbSec.count)
        }catch{
            print("coreData YbTime error")
        }
        
        if arrGlobalSet.count > 0 {
            nowGlobalSet = arrGlobalSet[0]
        }
    }
    
    // 第一次打开app，加入初始数据
    func firstOpenAPP() -> Void {
        getCoreData()
        
        // 初始化
        if arrGlobalSet.count > 0 {
            return
        }
        let oneGlobalSet = NSEntityDescription.insertNewObject(forEntityName: "CurGlobalSet", into: context) as! CurGlobalSet
        
        
        oneGlobalSet.curIndex = 0
        oneGlobalSet.openCount = 1      // 打开app次数
        oneGlobalSet.evaluate = 0       // 是否评分
        context.insert(oneGlobalSet)
        
        for _ in 0..<14 {
            let oneYb = NSEntityDescription.insertNewObject(forEntityName: "YbTime", into: context) as! YbTime
            oneYb.curSec = 0
            context.insert(oneYb)
        }

        appDelegate.saveContext()
        
        getCoreData()
    }
    
    func initUI() -> Void {
        
    }
}

