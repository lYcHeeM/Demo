//
//  ViewController.swift
//  03-first app <Tap me>
//
//  Created by luozhijun on 15/10/15.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var count = 0
    var seconds = 0
    var timer:NSTimer!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var buttonBeep: AVAudioPlayer?
    var secondBeep: AVAudioPlayer?
    var backgroundMusic: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_tile")!)
        scoreLabel.backgroundColor = UIColor(patternImage: UIImage(named: "field_score")!)
        timerLabel.backgroundColor = UIColor(patternImage: UIImage(named: "field_time")!)
        
        if let buttonBeep = setupAudioPlayerWithFile("ButtonTap", type: "wav") {
            self.buttonBeep = buttonBeep
        }
        if let secondBeep = setupAudioPlayerWithFile("SecondBeep", type: "wav") {
            self.secondBeep = secondBeep
        }
        if let backgroundMusic = setupAudioPlayerWithFile("HallOfTheMountainKing", type: "mp3") {
            self.backgroundMusic = backgroundMusic
        }
        
        setupGame()
    }
    
    func setupGame() {
        seconds = 30
        count = 0
        
        backgroundMusic?.volume = 0.1
        backgroundMusic?.play()
        
        timerLabel.text = "Time:\(seconds)"
        scoreLabel.text = "Score:\n\(count)"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.subtractTime), userInfo: nil, repeats: true)
    }
    
    func subtractTime() {
        seconds -= 1
        secondBeep?.play()
        timerLabel.text = "Time:\(seconds)"
        if (seconds == 0) {
            timer.invalidate()
            timer = nil
            let alert = UIAlertController(title: "Time is up", message: "You scored \(count) points", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.Default, handler: { action in self.setupGame()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
    @IBAction func buttonPressed() {
        count += 1
        buttonBeep?.play()
        scoreLabel.text = "Score\n\(count)"
    }
}

