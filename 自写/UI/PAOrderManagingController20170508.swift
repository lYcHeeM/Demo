
//
//  PAOrderManagingController.swift
//  wanjia2B
//
//  Created by luozhijun on 2017/4/7.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell
import MJRefresh

/** 我的--「订单管理」界面  */
class PAOrderManagingController: PABaseViewController {
    
    //MARK: - Properties
    fileprivate var tableViews = [PAOrderManagingTableView]()
    fileprivate let headerSliderTitles = ["待支付", "待受理", "已受理", "已完成", "退回/退款"]
    fileprivate let headerSliderTabHeight: CGFloat = 54
    fileprivate var headerSliderTab: CKSlideSwitchView!
    fileprivate var currentTableView: PAOrderManagingTableView {
        return tableViews[headerSliderTab.currentSelectedTabItemIndex()]
    }
    /// 无数据提示界面
    fileprivate lazy var emptyDataHintView: PAEmptyView = {
        let emptyView = PAEmptyView(frame: CGRect(x: (self.view.frame.size.width - 200)/2.0, y: 180, width: 200, height: 120), title: " ", marginTop: 0)
        emptyView.titleLabel.text = "暂无数据"
        emptyView.isUserInteractionEnabled = false
        return emptyView
    }()
    
    /// 用于标记是否第一次请求相应状态的订单数据
    var isFirstRequest = [false, false, false, false, false]
    fileprivate var diagnoseOrders = [[PADiagnoseOrder](), [PADiagnoseOrder](), [PADiagnoseOrder](), [PADiagnoseOrder](), [PADiagnoseOrder]()]
    fileprivate var subDiagnoseOrders: [PADiagnoseOrder] {
        if diagnoseOrders.count > headerSliderTab.currentSelectedTabItemIndex() {
            return diagnoseOrders[headerSliderTab.currentSelectedTabItemIndex()]
        } else {
            return []
        }
    }
    fileprivate func clearSubdianoseOrders() {
        if diagnoseOrders.count > headerSliderTab.currentSelectedTabItemIndex() {
            diagnoseOrders[headerSliderTab.currentSelectedTabItemIndex()].removeAll()
        }
    }
    fileprivate func removeSubdianoseOrders() {
        if diagnoseOrders.count > headerSliderTab.currentSelectedTabItemIndex() {
            diagnoseOrders.remove(at: headerSliderTab.currentSelectedTabItemIndex())
        }
    }
    
    fileprivate var pageNo = 1
    
    fileprivate var httpTasks = [URLSessionTask?]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        requestDiagnoseOrders()
        currentTableView.requestDiagnoseOrders()
        addNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        httpTasks.forEach { $0?.cancel() }
        deinitLog(self)
    }
}

//MARK: - Setup UI
extension PAOrderManagingController {
    fileprivate func setupUI() {
        title = "订单管理"
        setupTableViews()
        setupHeaderSliderTap()
    }
    
    fileprivate func setupTableViews() {
        var index = 1
        headerSliderTitles.forEach { _ in
//            let tableView = UITableView(frame: .zero, style: .plain)
//            tableView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64)
//            tableView.backgroundColor     = .paBackgroundColor()
//            tableView.separatorColor      = .paDividingColor()
//            tableView.dataSource          = self
//            tableView.delegate            = self
//            tableView.separatorStyle      = .none
//            tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
//                guard self != nil else { return }
//                self?.requestDiagnoseOrders(showHud: false, clearCache: true, orderStatus: self!.headerSliderTab.currentSelectedTabItemIndex() + 1)
//            })
//            (tableView.mj_header as? MJRefreshNormalHeader)?.lastUpdatedTimeLabel.isHidden = true
//            tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
//                guard self != nil else { return }
//                self?.requestDiagnoseOrders(accmulatePageNumber: true, orderStatus: self!.headerSliderTab.currentSelectedTabItemIndex() + 1)
//            })
//            tableView.register(PADiagnoseOrderCell.self, forCellReuseIdentifier: PADiagnoseOrderCell.reuseIdentifier)
//            tableViews.append(tableView)
            let tableView = PAOrderManagingTableView(orderIndex: index, container: self, emptyDataHintView: emptyDataHintView)
            tableView.isFirstRequest = isFirstRequest
            tableView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64)
            tableViews.append(tableView)
            index += 1
        }
    }
    
    fileprivate func setupHeaderSliderTap() {
        headerSliderTab = CKSlideSwitchView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64))
        headerSliderTab.tabItemTitleNormalColor      = UIColor.paGrayColor()
        headerSliderTab.tabItemTitleSelectedColor    = UIColor.paOrangeColor()
        headerSliderTab.topScrollViewBackgroundColor = UIColor.paBackgroundColor2()
        headerSliderTab.tabItemShadowColor           = UIColor.paOrangeColor()
        headerSliderTab.slideSwitchViewDelegate      = self
        view.addSubview(headerSliderTab)
        headerSliderTab.reloadData()
    }
}

//MARK: - Setup Data
extension PAOrderManagingController {
//    fileprivate func requestDiagnoseOrders(showHud: Bool = true, clearCache: Bool = false, accmulatePageNumber: Bool = false, orderStatus: Int = 1, reloadingTableView: UITableView? = nil) {
//        isFirstRequest[orderStatus - 1] = true
//        emptyDataHintView.removeFromSuperview()
//        if clearCache { pageNo = 1 }
//        if accmulatePageNumber { pageNo += 1 }
//        let pageSize = 10
//        let task = PAOrderManagingRequests.diagnoseOrders(for: showHud ? self : nil, page: pageNo, pageSize: pageSize, orderStatus: orderStatus) { [weak self] (orders, error) in
//            guard self != nil else { return }
//            
//            self!.currentTableView.mj_header.endRefreshing()
//            self!.currentTableView.mj_footer.endRefreshing()
//            
//            if let orders = orders, error == nil { // 请求成功且有数据
//                if clearCache {
//                    self!.clearSubdianoseOrders()
//                }
//                
//                var status_0_models = [PADiagnoseOrder]()
//                var status_1_models = [PADiagnoseOrder]()
//                var status_2_models = [PADiagnoseOrder]()
//                var status_3_models = [PADiagnoseOrder]()
//                var status_4_models = [PADiagnoseOrder]()
//                for model in orders {
//                    if model.status == 10 {
//                        status_0_models.append(contentsOf: [model])
//                    } else if model.status == 20 {
//                        status_1_models.append(contentsOf: [model])
//                    } else if model.status == 30 {
//                        status_2_models.append(contentsOf: [model])
//                    } else if model.status == 40 {
//                        status_3_models.append(contentsOf: [model])
//                    } else if model.status >= 50 {
//                        status_4_models.append(contentsOf: [model])
//                    }
//                }
//                var orderModelGroups = [status_0_models, status_1_models, status_2_models, status_3_models, status_4_models]
//                for index in 0..<orderModelGroups.count {
//                    let modelGroup = orderModelGroups[index]
//                    guard modelGroup.count > 0 else { continue }
//                    if !accmulatePageNumber {
//                        self!.removeSubdianoseOrders()
//                        self!.diagnoseOrders.insert(modelGroup, at: index)
//                    } else {
//                        self!.diagnoseOrders[self!.headerSliderTab.currentSelectedTabItemIndex()].append(contentsOf: modelGroup)
//                    }
//                }
//                
//                // 是否应该显示上拉加载更多
//                if self!.subDiagnoseOrders.count % pageSize != 0 || self!.subDiagnoseOrders.count == 0 {
//                    self!.currentTableView.mj_footer.isHidden = true
//                } else {
//                    self!.currentTableView.mj_footer.isHidden = false
//                }
//                
//                if reloadingTableView != nil {
//                    reloadingTableView?.reloadData()
//                } else {
//                    self!.currentTableView.reloadData()
//                }
//            } else { // 请求失败或无数据
//                if !accmulatePageNumber {
//                    self!.currentTableView.addSubview(self!.emptyDataHintView)
//                    self!.currentTableView.mj_footer.isHidden = true
//                    self!.clearSubdianoseOrders()
//                    self!.currentTableView.reloadData()
//                } else {
//                    self!.currentTableView.mj_footer.isHidden = true
//                }
//            }
//        }
//        httpTasks.append(task)
//    }
}

//MARK: - Notification
extension PAOrderManagingController {
    
    /// 通知
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCurrentList), name: Notification.Name.PADiagnoseOrderRefundSucceed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCurrentList), name: PAOrderDetailController.paySuccessNotifition, object: nil)
    }
    
    /// 「订单详情」-- 「立即支付」-- 「二维码支付」--支付成功--「订单详情」-- 返回
//    func detailControllerPaySuccess(){
//        debugLog("订单详情」-- 「立即支付」-- 「二维码支付」--支付成功--「订单详情」-- 返回")
//    }
    
}

//MARK: - Handle Events
extension PAOrderManagingController {
    @objc fileprivate func refreshCurrentList(note: Notification) {
//        requestDiagnoseOrders(orderStatus: self.headerSliderTab.currentSelectedTabItemIndex() + 1)
        currentTableView.requestDiagnoseOrders()
        if note.name == PAOrderDetailController.paySuccessNotifition {
//            requestDiagnoseOrders(orderStatus: 2, reloadingTableView: tableViews[1])
            tableViews[1].requestDiagnoseOrders()
        } else if note.name == Notification.Name.PADiagnoseOrderRefundSucceed {
//            requestDiagnoseOrders(orderStatus: 5, reloadingTableView: tableViews.last)
            tableViews.last?.requestDiagnoseOrders()
        }
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate
//extension PAOrderManagingController : UITableViewDataSource, UITableViewDelegate {

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return subDiagnoseOrders.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: PADiagnoseOrderCell.reuseIdentifier) as! PADiagnoseOrderCell
//        if tableView.contentInset.bottom == 0 {
//            tableView.contentInset.bottom = 0 + cell.tableViewBottomInset
//        }
//        cell.dataModel = subDiagnoseOrders[indexPath.row]
//        cell.payButtonClicked = { [weak self] usingCell in
//            PAOrderManagingRequests.check(orderID: usingCell.dataModel!.orderId!, for: self, finished: { [weak self] (orderDetail, error) in
//                if error == nil, let orderDetail = orderDetail {
//                    let payVc = PARegisterPaymentViewController()
//                    payVc.diagnoseOrder    = orderDetail
//                    payVc.turnBackRightNow = true
//                    self?.navigationController?.pushViewController(payVc, animated: true)
//                }
//            })
//        }
//        cell.deleteButtonClicked = { [weak self] (usingCell) in
//            guard self != nil else { return }
//            CustomAlertView.show(withMessage: "是否确认删除", confirmBtnCallBack: {
//                PAOrderManagingRequests.action(.delete, onOrder: usingCell.dataModel!.orderId!, for: self, finished: { (error) in
//                    if error == nil {
//                        self!.diagnoseOrders[self!.headerSliderTab.currentSelectedTabItemIndex()].remove(element: cell.dataModel!)
//                        tableView.deleteRows(at: [indexPath], with: .left)
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: { 
//                            if self!.subDiagnoseOrders.count <= 0 {
//                                self!.currentTableView.addSubview(self!.emptyDataHintView)
//                            }
//                        })
//                    }
//                })
//            }).show()
//        }
//        cell.refundButtonClicked = { [weak self] usingCell in
//            PAOrderManagingRequests.check(orderID: usingCell.dataModel!.orderId!, for: self, finished: { [weak self] (orderDetail, error) in
//                guard self != nil else { return }
//                if error == nil, let orderDetail = orderDetail {
//                    let refundVc = PADiagnoseRefundDetailController(diagnoseOrderDetail: orderDetail, orderManagingController: self!)
//                    self?.navigationController?.pushViewController(refundVc, animated: true)
//                }
//            })
//        }
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cellHeight = tableView.fd_heightForCell(withIdentifier: PADiagnoseOrderCell.reuseIdentifier, cacheBy: indexPath) { (cell) in
//            (cell as! PADiagnoseOrderCell).dataModel = self.subDiagnoseOrders[indexPath.row]
//        }
//        return cellHeight
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    
//        tableView.deselectRow(at: indexPath, animated: true)
//        let detailController = PAOrderDetailController(model: subDiagnoseOrders[indexPath.row],title:"订单详情")
//        detailController.deletOrderCallBack = { [weak self] in
//            /// 删除订单回调
//            let dataModel = self!.subDiagnoseOrders[indexPath.row]
//            self!.diagnoseOrders[self!.headerSliderTab.currentSelectedTabItemIndex()].remove(element: dataModel)
//            tableView.deleteRows(at: [indexPath], with: .left)
//        }
//        navigationController?.pushViewController(detailController, animated: true)
//    }
//}

extension PAOrderManagingController : CKSlideSwitchViewDelegate {
    func slideSwitchView(_ slideSwitchView: CKSlideSwitchView, heightForTabItemForTopScrollview topScrollview: UIScrollView) -> CGFloat {
        return headerSliderTabHeight
    }
    
    func slideSwitchView(_ slideSwitchView: CKSlideSwitchView, numberOfTabItemForTopScrollview topScrollview: UIScrollView) -> Int {
        return 5
    }
    
    func slideSwitchView(_ slideSwitchView: CKSlideSwitchView, titleForTabItemForTopScrollviewAt index: Int) -> String {
        return headerSliderTitles[index]
    }
    
    func slideSwitchView(_ slideSwitchView: CKSlideSwitchView, viewForRootScrollViewAt index: Int) -> UIView {
        return tableViews[index]
    }
    
    func slideSwitchView(_ slideSwitchView: CKSlideSwitchView!, imageNameForTabItemForTopScrollViewAt index: Int) -> String! {
        return ["ic_orderList_paying", "ic_orderList_dealing", "ic_orderList_dealt", "ic_orderList_completed", "ic_orderList_refund"][index]
    }
    
    func slideSwitchView(_ slideSwitchView: CKSlideSwitchView, widthForTabItemForTopScrollview topScrollview: UIScrollView) -> CGFloat {
        return view.frame.width/5.0
    }
    
    func slideSwitchView(_ slideSwitchView: CKSlideSwitchView, heightOfShadowImageForTopScrollview topScrollview: UIScrollView) -> CGFloat{
        return 1.5
    }
    
    func slideSwitchView(_ slideSwitchView: CKSlideSwitchView!, fontSizeForTabItemForTopScrollview topScrollview: UIScrollView!) -> CGFloat {
        return 14.0
    }
    
    func slideSwitchView(_ slideSwitchView: CKSlideSwitchView!, currentIndex index: Int) {
        if isFirstRequest[index] == false {
//            requestDiagnoseOrders(clearCache: true, orderStatus: index + 1)
            currentTableView.requestDiagnoseOrders()
        } else if currentTableView.subDiagnoseOrders.count == 0 {
            currentTableView.addSubview(emptyDataHintView)
        } else {
            emptyDataHintView.removeFromSuperview()
            currentTableView.reloadData()
        }
    }
}
