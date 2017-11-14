//
//  ViewController.swift
//  TeethGraph
//
//  Created by luozhijun on 2017/9/12.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var headerSliderTab: CKSlideSwitchView!
    let headerSliderTitles = ["恒牙", "乳牙"]
    let headerSliderTabHeight: CGFloat = 44
    var teetchViews = [PATeethView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
//        let pushBtn = UIButton(type: .detailDisclosure)
//        view.addSubview(pushBtn)
//        pushBtn.frame = CGRect(x: view.frame.width - 40, y: 80, width: 30, height: 30)
//        pushBtn.addTarget(self, action: #selector(pushBtnClicked), for: .touchUpInside)
        
//        let frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height)
//        let teethView = PADeciduousTeethView(frame: frame)
//        view.addSubview(teethView)
      
        setupTeethViews()
        setupHeaderSliderTap()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            print(self.teetchViews.first!.selectedTeethNumbers)
        }
    }
    
    fileprivate func setupTeethViews() {
        let startY = 64 + headerSliderTabHeight
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - startY)
        let permanentTeethView = PAPermanentTeethView(frame: frame, preselectedTeethNumbers: [11, 21, 31])
        let deciduousTeethView = PADeciduousTeethView(frame: frame, preselectedTeethNumbers: [51, 52, 53])
        teetchViews = [permanentTeethView, deciduousTeethView]
    }
    
    fileprivate func setupHeaderSliderTap() {
        headerSliderTab = CKSlideSwitchView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64))
        headerSliderTab.tabItemTitleNormalColor      = UIColor.gray
        headerSliderTab.tabItemTitleSelectedColor    = UIColor.orange
        headerSliderTab.topScrollViewBackgroundColor = UIColor.white
        headerSliderTab.tabItemShadowColor           = UIColor.orange
        headerSliderTab.slideSwitchViewDelegate      = self
        view.addSubview(headerSliderTab)
        headerSliderTab.reloadData()
    }

    @objc func pushBtnClicked() {
        let presentingVc = DeciduousTeethController()
        present(presentingVc, animated: true, completion: nil)
    }
}

//MARK: - CKSlideSwitchViewDelegate
extension ViewController : CKSlideSwitchViewDelegate {
    func slideSwitchView(_ view: CKSlideSwitchView, heightForTabItemForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return headerSliderTabHeight
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, numberOfTabItemsForTopScrollView topScrollView: UIScrollView) -> Int {
        return headerSliderTitles.count
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, titleForTabItemForTopScrollViewAt index: Int) -> String? {
        return headerSliderTitles[index]
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, viewForRootScrollViewAt index: Int) -> UIView? {
        return teetchViews[index]
    }
    
    func slideSwitchView(_ slideSwitchView: CKSlideSwitchView, currentIndex index: Int) {
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, tabItemWidthForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return view.frame.width/CGFloat(teetchViews.count)
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, heightOfShadowImageForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 1.5
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, tabItemFontSizeForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 14.0
    }
}

