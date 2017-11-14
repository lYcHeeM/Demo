//
//  PALineSegmentedView.swift
//  TeethGraph
//
//  Created by luozhijun on 2017/9/12.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

/// -----[view]-----[view]-----....
class PALineSegmentedView: UIView {
    
    enum LayoutDirection {
        case horizontal
        case vertical
    }
    
    fileprivate static let initialFrame = CGRect(x: -0.1, y: -0.1, width: 0, height: 0)
    
    fileprivate var layoutDirection: LayoutDirection = .horizontal
    fileprivate var lineColor = UIColor.lightGray
    fileprivate var separatingViews = [UIView]()
    
    required init(frame: CGRect, separatingViews: [UIView], lineColor: UIColor, layoutDirection: LayoutDirection = .horizontal) {
        super.init(frame: frame)
        self.lineColor = lineColor
        self.layoutDirection = layoutDirection
        self.separatingViews = separatingViews
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        var separatingViewsTotalSize = CGSize()
        for view in separatingViews {
            separatingViewsTotalSize.width += view.frame.width
            separatingViewsTotalSize.height += view.frame.height
        }
        let lineCount = separatingViews.count + 1
        let pixelSize = 1/UIScreen.main.scale
        var lineSize: CGSize!
        var padding: CGFloat = 1
        var layoutPoint = CGPoint()
        if layoutDirection == .horizontal {
            let lineTotalSize = frame.width - separatingViewsTotalSize.width - CGFloat(separatingViews.count) * 2 * padding
            lineSize = CGSize(width: lineTotalSize/CGFloat(lineCount), height: 2*pixelSize)
            if lineSize.width >= 2 * pixelSize {
                padding = pixelSize
            }
            layoutPoint.y = (frame.height - lineSize.height)/2
        } else {
            let lineTotalSize = frame.height - separatingViewsTotalSize.height - CGFloat(separatingViews.count) * 2 * padding
            lineSize = CGSize(width: 2*pixelSize, height: lineTotalSize/CGFloat(lineCount))
            if lineSize.height >= 2 * pixelSize {
                padding = pixelSize
            }
            layoutPoint.x = (frame.width - lineSize.width)/2
        }
        
        for index in 0..<lineCount {
            let lineView = UIView()
            addSubview(lineView)
            lineView.backgroundColor = lineColor
            lineView.frame.size = lineSize
            lineView.frame.origin = layoutPoint
            if layoutDirection == .horizontal {
                layoutPoint.x += lineView.frame.width + padding
            } else {
                layoutPoint.y += lineView.frame.height + padding
            }
            
            guard index != lineCount - 1 else { break }
            
            let separatingView = separatingViews[index]
            addSubview(separatingView)
            
            if layoutDirection == .horizontal {
                separatingView.frame.origin = CGPoint(x: layoutPoint.x, y: (frame.height - separatingView.frame.height)/2)
                layoutPoint.x += separatingView.frame.width + padding
            } else {
                separatingView.frame.origin = CGPoint(x: (frame.width - separatingView.frame.width)/2, y: layoutPoint.y)
                layoutPoint.y += separatingView.frame.height + padding
            }
        }
    }
}
