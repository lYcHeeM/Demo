//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by luozhijun on 2017/11/9.
//  Copyright © 2017年 luozhijun. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        request("https://httpbin.org/post").response { (response) in
//            print(response.request?.httpBodyStream)
//            print(response.response)
//            print(response.error)
//        }
//
//        request("https://httpbin.org/get").responseJSON { (JSON) in
//            print(JSON)
//        }
        
        let jwtHeader = "{\"alg\":\"HS512\"}"
        
        let date = Date()
        let curTime = Int(date.timeIntervalSince1970)
        let twoHourLater = curTime + 2 * 60 * 55
        let jwtPayload = "{\"sub\": \"pawjapp\",\"iat\": \(curTime),\"exp\": \(twoHourLater)}"
        
        let jointJwtBase64 = jwtHeader.base64EncodedString(with: .endLineWithCarriageReturn) + "." + jwtPayload.base64EncodedString(with: .endLineWithCarriageReturn)
        let encryptedDataBase64String = jointJwtBase64.encryptedString(with: .SHA512, isHmac: true, hmacKey: "tzVIhxznsUR2").1
        var token = jointJwtBase64 + "." + encryptedDataBase64String
        token.replaceBase64ParticularChars()
        
        let httpHeader: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let params = [
            "serialNum": "",
            "idNo": "",
            "photoStr": "",
            "name": "",
            "clinicId": "",
            "userId": "",
            "mobileNo": ""
        ]
        request("https://opentest.pawjzs.com/i/open/faceRecognition/compare.json", method: .get, parameters: params, headers: httpHeader).response { (JSON) in
            print(JSON)
        }
    }
}

