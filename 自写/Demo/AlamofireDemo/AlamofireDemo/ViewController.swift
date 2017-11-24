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
        let clinicId = "a018f483-7002-4baa-ab90-604bb27d721b"
        let userId = "691"
        let imgData = UIImagePNGRepresentation(#imageLiteral(resourceName: "Shake_Received_Icon"))
        let imgBase64 = imgData?.base64EncodedString(options: .endLineWithCarriageReturn) ?? ""
        let serialNum = "sdaf1lj1l3jlj1111"
        let params = [
            "serialNum": serialNum,
            "idNo": "360782199301050212",
            "photoStr": imgBase64,
            "name": "zhangsan",
            "clinicId": clinicId,
            "userId": userId,
            "mobileNo": "13333333333"
        ]
        request("https://opentest.pawjzs.com/i/open/faceRecognition/compare.json?serialNum=\(serialNum)&channelType=QHZX", method: .post, parameters: params, encoding: JSONEncoding.default, headers: httpHeader).responseJSON { (JSON) in
            print(JSON)
        }
    }
}

