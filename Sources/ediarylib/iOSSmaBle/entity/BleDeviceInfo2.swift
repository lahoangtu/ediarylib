//
//  BleDeviceInfo2.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2022/12/6.
//  Copyright © 2022 CodingIOT. All rights reserved.
//

import UIKit

/// 精简的设备信息
class BleDeviceInfo2: BleReadable {

    var mBleAddress: String = ""
    var mClassicAddress: String = ""
    var mFirmwareVersion: String = "0.0.0"
    var mUiVersion: String = "0.0.0"
    var mLanguageVersion: String = "0.0.0"
    var mLanguageCode: Int = Languages.DEFAULT_CODE
    var mBleName: String = ""
    
    
    override func decode() {
        super.decode()
        mBleAddress = readStringUtil(0).uppercased()
        mClassicAddress = readStringUtil(0).uppercased()
        
        mFirmwareVersion = toVersion(bytes: readData(3), separator: ".")
        mUiVersion = toVersion(bytes: readData(3), separator: ".")
        mLanguageVersion = toVersion(bytes: readData(3), separator: ".")
        
        mLanguageCode = Int(readUInt8())
        mBleName = readStringUtil(0)
    }
    
    func toDictionary()->[String:Any]{
        let dic : [String : Any] = [
            "mBleAddress": mBleAddress,
            "mClassicAddress": mClassicAddress,
            "mFirmwareVersion": mFirmwareVersion,
            "mUiVersion": mUiVersion,
            "mLanguageVersion": mLanguageVersion,
            "mLanguageCode": mLanguageCode,
            "mBleName": mBleName
        ]
        return dic
    }
    
    func dictionaryToObjct(_ dic:[String:Any]) -> BleDeviceInfo2{

        let newModel = BleDeviceInfo2()
        if dic.keys.count<1{
            return newModel
        }
        newModel.mBleAddress = dic["mBleAddress"] as? String ?? ""
        newModel.mClassicAddress = dic["mClassicAddress"] as? String ?? ""
        newModel.mFirmwareVersion = dic["mFirmwareVersion"] as? String ?? ""
        newModel.mUiVersion = dic["mUiVersion"] as? String ?? ""
        newModel.mLanguageVersion = dic["mLanguageVersion"] as? String ?? ""
        newModel.mLanguageCode = dic["mLanguageCode"] as? Int ?? Languages.DEFAULT_CODE
        newModel.mBleName = dic["mBleName"] as? String ?? ""
        
        return newModel
    }
    
    private func toVersion(bytes: Data, separator: String) -> String {
        
        return bytes.map {
            if $0 > 9 {
                return "0"
            } else {
                return "\($0)"
            }
        }.joined(separator: separator)
    }
    
    override var description: String {
        return "BleDeviceInfo2(mBleAddress: \(mBleAddress), mClassicAddress: \(mClassicAddress), mFirmwareVersion: \(mFirmwareVersion)"
        + ", mUiVersion:\(mUiVersion), mLanguageVersion:\(mLanguageVersion), mLanguageCode:\(mLanguageCode), mBleName:\(mBleName))"
    }
}
