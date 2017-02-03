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
    @IBOutlet weak var btnBack1: UIButton!
    @IBOutlet weak var btnBack5: UIButton!
    @IBOutlet weak var btnNext1: UIButton!
    @IBOutlet weak var btnNext5: UIButton!
    
    var arrPlayer = [AVAudioPlayer]()
    
    var timer:Timer!
    var curTime:Int32 = 0
    var arrCurTime = [Int32]()
    var curRow:Int = -1
    var isPlaying:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        firstOpenAPP()
        
        for i in 0..<gName.count {
            initAudio(row: i)
            arrCurTime.append(0)
        }

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tickDown), userInfo: nil, repeats: true)
    }
    
    func tickDown() -> Void {
        if isPlaying {
            curTime = curTime + 1
        }
        
        print("tick down", curTime)
    }
    
    @IBAction func GoBack1(_ sender: Any) {
    }
    
    @IBAction func GoBack5(_ sender: Any) {
    }
    
    @IBAction func GoNext1(_ sender: Any) {
    }
    
    @IBAction func GoNext5(_ sender: Any) {
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("de sel")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if curRow == indexPath.row {
            if isPlaying {
                //  暂停
                isPlaying = false
                arrPlayer[curRow].stop()
                arrCurTime[curRow] = curTime
                print("pause", curTime)
            }else {
                // 播放
                curTime = arrCurTime[curRow]
                let player = arrPlayer[curRow]
                let ctime:Double = Double(curTime)
                player.currentTime = ctime
                print("play:", curTime, player.currentTime)
                player.play()
                isPlaying = true
            }
        }else {
            if curRow >= 0 {
                arrPlayer[curRow].stop()
            }

            if isPlaying {
                //  暂停
                isPlaying = false
                arrCurTime[curRow] = curTime
                
                curRow = indexPath.row
            }else {
                // 播放
                curRow = indexPath.row
                
                curTime = arrCurTime[curRow]
                let player = arrPlayer[curRow]
                let ctime:Double = Double(curTime)
                player.currentTime = ctime
                player.play()
                isPlaying = true
            }
            
           
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

