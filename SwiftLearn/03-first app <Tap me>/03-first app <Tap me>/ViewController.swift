//
//  ViewController.swift
//  03-first app <Tap me>
//
//  Created by luozhijun on 15/10/15.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var count = 0
    var seconds = 0
    var timer:NSTimer!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGame()
    }
    
    func setupGame() {
        seconds = 30
        count = 0
        
        timerLabel.text = "Time:\(seconds)"
        scoreLabel.text = "Score:\n\(count)"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
    }
    
    func subtractTime() {
        seconds--
        timerLabel.text = "Time:\(seconds)"
        if (seconds == 0) {
            timer.invalidate()
            timer = nil
            let alert = UIAlertController(title: "Time is up", message: "You scored \(count) points", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.Default, handler: { action in self.setupGame()
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    @IBAction func buttonPressed() {
        count++
        scoreLabel.text = "Score\n\(count)"
        
//        let nextVc =  WebViewController()
//        self.presentViewController(nextVc, animated: true, completion: nil)
    }
}

