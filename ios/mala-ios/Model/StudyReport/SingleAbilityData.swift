//
//  SingleAbilityData.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/31.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class SingleAbilityData: NSObject {
    
    // MARK: - Property
    /// 能力名称（简略）
    var name: String = ""
    /// 数值
    var value: Int = 0
    /// 能力
    var ability: MalaStudyReportAbility {
        get {
            return MalaStudyReportAbility(rawValue: name) ?? .unkown
        }
    }
    /// 能力字符串
    var abilityString: String {
        get {
            switch ability {
            case .abstract:
                return "抽象概括能力"
                
            case .reason:
                return "推理论证能力"
                
            case .appl:
                return "实际应用能力"
                
            case .spatial:
                return "空间想象能力"
                
            case .calc:
                return "运算求解能力"
                
            case .data:
                return "数据分析能力"
                
            case .unkown:
                return ""
            }
        }
    }
    
    
    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    
    convenience init(name: String, value: Int) {
        self.init()
        self.name = name
        self.value = value
    }
}