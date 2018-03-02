//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by luozhijun on 2017/11/9.
//  Copyright © 2017年 luozhijun. All rights reserved.
//

import UIKit
import Alamofire
import QuickLook

class ViewController: UIViewController, QLPreviewControllerDataSource, UIDocumentInteractionControllerDelegate {

    var localPdfPath: String!
    
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
        
        download("https://imagetest.pawjzs.com/elecsignature/3/3e35dbe8-d2c2-447b-8aa6-0adf845ba522/rBIyX1omUZyIKZbeAALzShsDrnYAAACyQBIxjQAAvNi384.pdf") { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/aaa.pdf"
            let url = URL(fileURLWithPath: path)
            return (url, [.createIntermediateDirectories, .removePreviousFile])
        }.response { (response) in
            guard let path = response.destinationURL?.path else { return }
            print(path)
            
            // how to display pdf file with signature
//            #1
//            let qlVc = QLPreviewController()
//            self.localPdfPath = path
//            qlVc.dataSource = self
//            self.present(qlVc, animated: true, completion: nil)
            
//            #2
//            let vc = UIDocumentInteractionController(url: response.destinationURL!)
//            vc.delegate = self
//            vc.presentPreview(animated: true)
            
//            #3
//            UIApplication.shared.open(URL(string: "http://fs01stg.pinganwj.com:81/group1/M00/00/04/rBIyX1olOGOIRalPAALwYmQZ9g0AAACyAPfTj0AAvB6833.pdf")!, completionHandler: nil)
            
//            #4 the only way to display signatures on pdf file of these 4 methods
            let pdfJsWebView = PDFWebView()
            self.view.addSubview(pdfJsWebView)
            pdfJsWebView.frame = self.view.bounds
            pdfJsWebView.loadPDF(with: path)
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        controller.navigationItem.rightBarButtonItem = nil
        return NSURL(fileURLWithPath: localPdfPath)
    }
    
    func jwtTokenDemo() {
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

