//
//  BleHmTime.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2022/11/30.
//  Copyright © 2022 CodingIOT. All rights reserved.
//

import UIKit

class BleHmTime: BleWritable {

    static let ITEM_LENGTH = 2
    
    override var mLengthToWrite: Int {
        return BleHmTime.ITEM_LENGTH
    }
    
    var mHour: Int = 0
    var mMinute: Int = 0
    
    override func encode() {
        super.encode()
        writeInt8(mHour)
        writeInt8(mMinute)
    }
    
    override func decode() {
        super.decode()
        mHour = Int(readUInt8())
        mMinute = Int(readUInt8())
    }
    
    func dictionaryToObjct(_ dic:[String:Any]) -> BleHmTime {
        let newModel = BleHmTime()
        newModel.mHour = dic["mHour"] as? Int ?? 0
        newModel.mMinute = dic["mMinute"] as? Int ?? 0
        return newModel
    }
    
    func toDictionary()->[String:Any]{
        let dic : [String : Any] = ["mHour":mHour,
                                    "mMinute":mMinute]
        return dic
    }
    
    override var description: String {
        "BleHmTime(mHour: \(mHour), mMinute: \(mMinute))"
    }
}
