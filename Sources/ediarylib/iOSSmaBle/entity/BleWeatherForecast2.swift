//
//  BleWeatherForecast2.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2022/12/6.
//  Copyright © 2022 CodingIOT. All rights reserved.
//

import UIKit

class BleWeatherForecast2: BleWritable {
    var mTime: Int = 0 // 时间戳，秒数
    var mCityName: String = "" //城市名
    var mWeather1: BleWeather2?
    var mWeather2: BleWeather2?
    var mWeather3: BleWeather2?
    var mWeather4: BleWeather2?
    var mWeather5: BleWeather2?
    var mWeather6: BleWeather2?
    var mWeather7: BleWeather2?
    
    
    static let NAME_LENGTH = 66
    private let ITEM_LENGTH = BleTime.ITEM_LENGTH + NAME_LENGTH + BleWeather2.ITEM_LENGTH * 7
    override var mLengthToWrite: Int {
        return ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeObject(BleTime.ofLocal(mTime))
        writeStringWithFix(mCityName, BleWeatherForecast2.NAME_LENGTH)
        writeObject(mWeather1)
        writeObject(mWeather2)
        writeObject(mWeather3)
        writeObject(mWeather4)
        writeObject(mWeather5)
        writeObject(mWeather6)
        writeObject(mWeather7)
    }
    
    func dictionaryToObjct(_ dic:[String:Any]) -> BleWeatherForecast2 {
        
        let newModel = BleWeatherForecast2()
        if dic.keys.isEmpty {
            return newModel
        }
        newModel.mTime = dic["mTime"] as? Int ?? 0
        newModel.mCityName = dic["mCityName"] as? String ?? ""
        
        let dic1 : [String:Any] = dic["mWeather1"] as? [String:Any] ?? [:]
        newModel.mWeather1 = BleWeather2().dictionaryToObjct(dic1)
        
        let dic2 : [String:Any] = dic["mWeather2"] as? [String:Any] ?? [:]
        newModel.mWeather2 = BleWeather2().dictionaryToObjct(dic2)
        
        let dic3 : [String:Any] = dic["mWeather3"] as? [String:Any] ?? [:]
        newModel.mWeather3 = BleWeather2().dictionaryToObjct(dic3)
        
        let dic4 : [String:Any] = dic["mWeather4"] as? [String:Any] ?? [:]
        newModel.mWeather4 = BleWeather2().dictionaryToObjct(dic4)
        
        let dic5 : [String:Any] = dic["mWeather5"] as? [String:Any] ?? [:]
        newModel.mWeather5 = BleWeather2().dictionaryToObjct(dic5)
        
        let dic6 : [String:Any] = dic["mWeather6"] as? [String:Any] ?? [:]
        newModel.mWeather6 = BleWeather2().dictionaryToObjct(dic6)
        
        let dic7 : [String:Any] = dic["mWeather7"] as? [String:Any] ?? [:]
        newModel.mWeather7 = BleWeather2().dictionaryToObjct(dic7)
                
        return newModel
    }

    override var description: String {
        let tempTime = BleTime.ofLocal(mTime)
        return "BleWeatherForecast2(mTime=\(tempTime), mWeather1=\(String(describing: mWeather1))" +
        ", mWeather2=\(String(describing: mWeather2)), mWeather3=\(String(describing: mWeather3))" +
        ", mWeather4=\(String(describing: mWeather4)), mWeather5=\(String(describing: mWeather5))" +
        ", mWeather6=\(String(describing: mWeather6)), mWeather7=\(String(describing: mWeather7)))"
    }

}
