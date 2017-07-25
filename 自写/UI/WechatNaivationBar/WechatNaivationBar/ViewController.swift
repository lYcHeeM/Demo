//
//  ViewController.swift
//  WechatNaivationBar
//
//  Created by luozhijun on 2016/12/21.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.insertSubview(self.gradientView, at: 0)
        
        let gradientView = self.gradientView
        gradientView.frame = CGRect(x: 60, y: 100, width: 300, height: 100)
        tableView.addSubview(gradientView)
    }

    var gradientView: UIView {
        let gradientView   = UIView()
        gradientView.alpha = 0.5
        gradientView.backgroundColor = UIColor(colorLiteralRed: 50/255.0, green: 6/255.0, blue: 128/255.0, alpha: 1.0)
        gradientView.frame = CGRect(x: 0, y: -20, width: view.frame.width, height: 64)
        let layer          = CAGradientLayer()
        layer.frame        = gradientView.bounds
        //layer.colors       = [UIColor(colorLiteralRed: 0x04/255.0, green: 0, blue: 0x12/255.0, alpha: 0.76).cgColor, UIColor(colorLiteralRed: 0x04/255.0, green: 0, blue: 0x12/255.0, alpha: 0.28).cgColor]
        //layer.colors = [UIColor(colorLiteralRed: 255/255.0, green: 155/255.0, blue: 0, alpha: 0.9).cgColor, UIColor(colorLiteralRed: 255/255.0, green: 155/255.0, blue: 0, alpha: 0.5).cgColor]
        layer.startPoint   = CGPoint.zero
        layer.endPoint     = CGPoint(x: 0, y: 1)
        gradientView.layer.addSublayer(layer)
        gradientView.isUserInteractionEnabled = false
        return gradientView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        if indexPath.row % 3 == 0 {
            cell?.imageView?.image = UIImage(named: "ic_head")
        } else if indexPath.row % 3 == 1 {
            cell?.imageView?.image = UIImage(named: "ic_coupon")
        } else {
            cell?.imageView?.image = UIImage(named: "ic_profile_car")
        }
        return cell!
    }
}

