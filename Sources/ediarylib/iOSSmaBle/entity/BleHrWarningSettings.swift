//
//  BleHrWarningSettings.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2022/12/6.
//  Copyright © 2022 CodingIOT. All rights reserved.
//

import UIKit

class BleHrWarningSettings: BleWritable {

    /// 心率过高提醒开关
    var mHighSwitch: Int = 0
    /// 过高心率提醒阈值
    var mHighValue: Int = 0
    /// 心率过低提醒开关
    var mLowSwitch: Int = 0
    /// 过低心率提醒阈值
    var mLowValue: Int = 0
    
    
    private let ITEM_LENGTH = 4
    override var mLengthToWrite: Int {
        return ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeInt8(mHighSwitch )
        writeInt8(mHighValue)
        writeInt8(mLowSwitch)
        writeInt8(mLowValue)
    }

    override func decode() {
        super.decode()
        mHighSwitch = Int(readInt8())
        mHighValue = Int(readInt8())
        mLowSwitch = Int(readUInt8())
        mLowValue = Int(readUInt8())
    }
    
    override var description: String {
        return "BleHrWarningSettings(mHighSwitch=\(mHighSwitch), mHighValue=\(mHighValue), mLowSwitch=\(mLowSwitch), mLowValue=\(mLowValue))"
    }
}
