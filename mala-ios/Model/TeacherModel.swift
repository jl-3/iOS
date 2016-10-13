//
//  TeacherModel.swift
//  mala-ios
//
//  Created by Erdi on 12/23/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

class TeacherModel: BaseObjectModel {
    
    // MARK: - Property
    var avatar: URL?
    var gender: String?
    var level: Int = 0
    var min_price: Int = 0
    var max_price: Int = 0
    var subject: String?
    var grades_shortname: String?
    var tags: [String]?
    
    
    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    override init(dict: [String: AnyObject]) {
        super.init(dict: dict)
        setValuesForKeys(dict)
    }
    
    convenience init(id: Int, name: String, avatar: String, degree: Int, minPrice: Int, maxPrice: Int, subject: String, shortname: String, tags: [String]) {
        self.init()
        self.id = id
        self.name = name
        self.avatar = URL(string: avatar)
        self.level = degree
        self.min_price = minPrice
        self.max_price = maxPrice
        self.subject = subject
        self.grades_shortname = shortname
        self.tags = tags
    }
    
    convenience init(id: Int, name: String, avatar: String) {
        self.init()
        self.id = id
        self.name = name
        self.avatar = URL(string: avatar)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("TeacherModel - Set for UndefinedKey: \(key)")
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        // keep the price's value to 0(Int), if the value is null
        if (key == "min_price" || key == "max_price") && value == nil {
            return
        }
        if key == "avatar" {
            if let urlString = value as? String {
                avatar = URL(string: urlString)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    
    // MARK: - Description
    override var description: String {
        let keys = ["id", "name", "avatar", "gender", "level", "min_price", "max_price", "subject", "grades_shortname", "tags"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
