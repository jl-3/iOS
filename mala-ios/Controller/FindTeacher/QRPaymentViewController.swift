//
//  QRPaymentViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 2016/11/10.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    
    var backgroundColor: UIColor {
        return MalaColor_EDEDED_0
    }
    
    fileprivate var componentType: ComponentType {
        return .menuView(menuOptions: MenuOptions())
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var backgroundColor: UIColor {
            return MalaColor_FDFDFD_0
        }
        var selectedBackgroundColor: UIColor {
            return MalaColor_FDFDFD_0
        }
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
        var focusMode: MenuFocusMode {
            return .underline(height: 2, color: MalaColor_8DBEDE_0, horizontalPadding: 30, verticalPadding: 0)
        }
    }
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "微信支付", color: MalaColor_7E7E7E_0, selectedColor: MalaColor_8DBEDE_0))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "支付宝支付", color: MalaColor_7E7E7E_0, selectedColor: MalaColor_8DBEDE_0))
        }
    }
}


class QRPaymentViewController: BaseViewController {
    
    // MARK: - Components
    /// 二维码信息
    private lazy var qrView: QRCodeView = {
        let view = QRCodeView()
        return view
    }()
    /// 完成提示文字
    private lazy var tipFinishString: UILabel = {
        let label = UILabel(
            font: UIFont(name: "PingFang-SC-Regular", size: 12),
            textColor: MalaColor_636363_0
        )
        
        let string = "家长完成支付后 点击支付完成按钮"
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(
            NSForegroundColorAttributeName,
            value: MalaColor_9BC3E1_0,
            range: NSMakeRange(10, 4)
        )
        attrString.addAttribute(
            NSFontAttributeName,
            value: UIFont(name: "PingFang-SC-Regular", size: 12)!,
            range: NSMakeRange(10, 4)
        )
        
        label.attributedText = attrString
        return label
    }()
    /// 支付按钮
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.withColor(MalaColor_9BC3E1_0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("支付完成", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(QRPaymentViewController.confirmButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        setupPageController()
        
        /// 获取支付信息
        getChargeToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        title = "扫码支付"
        view.backgroundColor = MalaColor_F2F2F2_0
        
        // SubViews
        view.addSubview(qrView)
        view.addSubview(tipFinishString)
        view.addSubview(confirmButton)
        
        // Autolayout
        qrView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view)
            maker.bottom.equalTo(view).multipliedBy(0.73)
            maker.width.equalTo(view).multipliedBy(0.85)
            maker.height.equalTo(view).multipliedBy(0.565)
        }
        tipFinishString.snp.makeConstraints { (maker) in
            maker.height.equalTo(16.5)
            maker.bottom.equalTo(view).multipliedBy(0.843)
            maker.centerX.equalTo(view)
        }
        confirmButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view)
            maker.height.equalTo(44)
            maker.width.equalTo(view).multipliedBy(0.85)
            maker.bottom.equalTo(view).multipliedBy(0.95)
        }
    }
    
    private func setupPageController() {
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.delegate = self
        pagingMenuController.view.frame.size = CGSize(width: MalaScreenWidth, height: 64)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
    
    func getChargeToken(channel: MalaPaymentChannel = .WxQR) {
        
        MalaIsPaymentIn = true
        ThemeHUD.showActivityIndicator()
        
        ///  获取支付信息
        getChargeTokenWithChannel(channel, orderID: ServiceResponseOrder.id, failureHandler: { (reason, errorMessage) -> Void in
            
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("PaymentViewController - getGharge Error \(errorMessage)")
            }
            
        }, completion: { [weak self] (charges) -> Void in
            println("获取支付信息:\(charges)")
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                ThemeHUD.hideActivityIndicator()
                
                /// 验证返回值是否有效
                guard let charge = charges else {
                    self?.ShowTost("支付信息错误，请重试")
                    return
                }
                
                /// 验证返回结果是否存在result(存在则表示失败)
                if let _ = charge["result"] as? Bool {
                    /// 失败弹出提示
                    if let strongSelf = self {
                        let alert = JSSAlertView().show(strongSelf,
                                                        title: "部分课程时间已被占用，请重新选择上课时间",
                                                        buttonText: "重新选课",
                                                        iconImage: UIImage(named: "alert_PaymentFail")
                        )
                        alert.addAction(strongSelf.forcePop)
                    }
                }else {
                    /// 成功保存Charge对象
                    MalaPaymentCharge = charge
                    
                    /// 验证数据正确性
                    guard let credential = charge["credential"] as? JSONDictionary else {
                        println("credential 对象不存在！")
                        return
                    }
                    
                    /// 获取支付链接，生成二维码
                    guard let qrPaymentURL = credential["wx_pub_qr"] as? String else {
                        println("QR URL 不存在！")
                        return
                    }
                    
                    self?.qrView.url = qrPaymentURL
                    self?.qrView.price = ServiceResponseOrder.amount == 0 ? MalaCurrentCourse.getAmount() ?? 0 : ServiceResponseOrder.amount
                }
            })
        })
    }
    
    private func cancelOrder() {
        
        println("取消订单")
        ThemeHUD.showActivityIndicator()
        
        cancelOrderWithId(ServiceResponseOrder.id, failureHandler: { (reason, errorMessage) in
            ThemeHUD.hideActivityIndicator()
            
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("PaymentViewController - cancelOrder Error \(errorMessage)")
            }
        }, completion:{ [weak self] (result) in
            ThemeHUD.hideActivityIndicator()
            println("取消订单结果 - \(result)")
            DispatchQueue.main.async(execute: { () -> Void in
                _ = self?.navigationController?.popViewController(animated: true)
            })
        })
    }
    
    private func validateOrderStatus() {
        
        ThemeHUD.showActivityIndicator()
        
        // 获取订单信息
        getOrderInfo(ServiceResponseOrder.id, failureHandler: { (reason, errorMessage) -> Void in
            ThemeHUD.hideActivityIndicator()
            
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("QRPaymentViewController - validateOrderStatus Error \(errorMessage)")
            }
        }, completion: { [weak self] order -> Void in
            println("订单状态获取成功 \(order.status)")
            
            // 根据[订单状态]和[课程是否被抢占标记]来判断支付结果
            DispatchQueue.main.async { () -> Void in
                ThemeHUD.hideActivityIndicator()
                
                let handler = HandlePingppBehaviour()
                handler.currentViewController = self
                
                // 判断订单状态
                // 尚未支付
                if order.status == MalaOrderStatus.penging.rawValue {
                    self?.ShowTost("请完成付款后，点击支付完成")
                    return
                }
                // 支付成功
                if order.status == MalaOrderStatus.paid.rawValue {
                    
                    if order.isTeacherPublished == false {
                        // 老师已下架
                        handler.showTeacherDisabledAlert()
                    }else if order.isTimeslotAllocated == false {
                        // 课程被抢买
                        handler.showHasBeenPreemptedAlert()
                    }else {
                        // 支付成功
                        handler.showSuccessAlert()
                    }
                }else {
                    self?.ShowTost("请重试")
                    return
                }
            }
        })
    }
    
    
    // MARK: -  Events Response
    @objc private func forcePop() {
        cancelOrder()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func confirmButtonDidTap() {
        validateOrderStatus()
    }
}


// MARK: - PagingMenu Delegate
extension QRPaymentViewController: PagingMenuControllerDelegate {

    func didMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
        
        guard let title = menuItemView.titleLabel.text else {
            println("didMove - MenuItemView no title")
            return
        }
        
        switch title {
        case "微信支付":
            getChargeToken(channel: .WxQR)
            break
            
        case "支付宝支付":
            getChargeToken(channel: .AliQR)
            break
            
        default:
            break
        }
        
    }
}
