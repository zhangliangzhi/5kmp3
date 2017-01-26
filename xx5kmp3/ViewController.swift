//
//  ViewController.swift
//  xx5kmp3
//
//  Created by ZhangLiangZhi on 2017/1/25.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var arrPlayer = [AVAudioPlayer]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        for i in 0..<gName.count {
            initAudio(row: i)
        }
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
        
        for i in 0..<gName.count {
            arrPlayer[i].stop()
        }
        
        let player = arrPlayer[indexPath.row]
        player.play()
    }

}

