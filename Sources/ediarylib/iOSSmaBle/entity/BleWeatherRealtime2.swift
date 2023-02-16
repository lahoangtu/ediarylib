//
//  BleWeatherRealtime2.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2022/12/6.
//  Copyright © 2022 CodingIOT. All rights reserved.
//

import UIKit

class BleWeatherRealtime2: BleWritable {

    /// 时间戳，秒数/
    var mTime: Int = 0
    /// 城市名
    var mCityName: String = ""
    var mWeather: BleWeather2?
    
    
    private static let NAME_LENGTH = 66
    private let ITEM_LENGTH = BleTime.ITEM_LENGTH + NAME_LENGTH + BleWeather2.ITEM_LENGTH
    override var mLengthToWrite: Int {
        return ITEM_LENGTH
    }
    
    
    override func encode() {
        super.encode()
        writeObject(BleTime.ofLocal(mTime))
        writeStringWithFix(mCityName, BleWeatherRealtime2.NAME_LENGTH)
        writeObject(mWeather)
    }
    
    func dictionaryToObjct(_ dic:[String:Any]) ->BleWeatherRealtime2{
        
        let newModel = BleWeatherRealtime2()
        if dic.keys.isEmpty {
            return newModel
        }
        newModel.mTime = dic["mTime"] as? Int ?? 0
        newModel.mCityName = dic["mCityName"] as? String ?? ""
        
        let dic1 : [String:Any] = dic["mWeather"] as? [String:Any] ?? [:]
        newModel.mWeather = BleWeather2().dictionaryToObjct(dic1)
                
        return newModel
    }
    

    override var description: String {
        let tempTime = BleTime.ofLocal(mTime)
        return "BleWeatherRealtime2(mTime=\(tempTime), mCityName=\(mCityName), mWeather=\(String(describing: mWeather)))"
    }
}
