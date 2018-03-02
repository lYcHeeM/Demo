//
//  PDFWebView.swift
//  AlamofireDemo
//
//  Created by luozhijun on 2017/12/5.
//  Copyright © 2017年 luozhijun. All rights reserved.
//

import UIKit

class PDFWebView: UIWebView {
    var pdfFilePath: String?
    
    func loadPDF(with path: String) {
        pdfFilePath = path
        
        guard let pdfViewerPath = Bundle.main.path(forResource: "viewer", ofType: "html", inDirectory:"minified/web") else { return }
        let urlString = "\(pdfViewerPath)?file=\(path)#page1"
        guard let escapedUrlStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: escapedUrlStr) else { return }
        let req = URLRequest(url: url)
        loadRequest(req)
    }

}
