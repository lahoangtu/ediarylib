//
//  BleWeather2.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2022/12/6.
//  Copyright © 2022 CodingIOT. All rights reserved.
//

import UIKit

enum BleWeather2Type: Int {
    /// 没有天气
    case OTHER = 0
    /// 晴
    case SUNNY = 1
    /// 多云
    case CLOUDY
    /// 阴天
    case OVERCAST
    /// 雨天
    case RAINY
    /// 打雷
    case THUNDER
    /// 雷阵雨
    case THUNDERSHOWER
    /// 大风
    case HIGH_WINDY
    /// 下雪
    case SNOWY
    /// 雾气
    case FOGGY
    /// 沙尘暴
    case SAND_STORM
    /// 阴霾
    case HAZE
    /// 凤
    case WIND
    /// 细雨
    case DRIZZLE
    /// 大雨
    case HEAVY_RAIN
    /// 闪电
    case LIGHTNING
    /// 小雪
    case LIGHT_SNOW
    /// 暴雪
    case HEAVY_SNOW
    /// 雨夹雪，冻雨；雨淞
    case SLEET
    /// 龙卷风
    case TORNADO
    /// 暴风雪
    case SNOWSTORM
}

class BleWeather2: BleWritable {

    var mCurrentTemperature: Int = 0 // 摄氏度，for BleWeatherRealtime
    var mMaxTemperature: Int = 0     // 摄氏度，for BleWeatherForecast
    var mMinTemperature: Int = 0     // 摄氏度，for BleWeatherForecast
    var mWeatherCode: Int = 0        // 天气类型，for both
    var mWindSpeed: Int = 0          // km/h，for both
    var mHumidity: Int = 0           // %，for both
    var mVisibility: Int = 0         // km，for both
    // https://en.wikipedia.org/wiki/Ultraviolet_index
    // https://zh.wikipedia.org/wiki/%E7%B4%AB%E5%A4%96%E7%BA%BF%E6%8C%87%E6%95%B0
    // [0, 2] -> low, [3, 5] -> moderate, [6, 7] -> high, [8, 10] -> very high, >10 -> extreme
    var mUltraVioletIntensity: Int = 0 // 紫外线强度，for BleWeatherForecast
    var mPrecipitation: Int = 0        // 降水量 mm，for both
    var mSunriseHour: Int = 0          // 日出小时
    var mSunrisMinute: Int = 0         // 日出分钟
    var mSunrisSecond: Int = 0         // 日出秒
    var mSunsetHour: Int = 0           // 日落小时
    var mSunsetMinute: Int = 0         // 日落分钟
    var mSunsetSecond: Int = 0         // 日落秒
    
    static let ITEM_LENGTH = 20
    override var mLengthToWrite: Int {
        return BleWeather2.ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeInt8(mCurrentTemperature)
        writeInt8(mMaxTemperature)
        writeInt8(mMinTemperature)
        writeInt16(mWeatherCode, ByteOrder.LITTLE_ENDIAN)
        writeInt8(mWindSpeed)
        writeInt8(mHumidity)
        writeInt8(mVisibility)
        writeInt8(mUltraVioletIntensity)
        writeInt16(mPrecipitation, ByteOrder.LITTLE_ENDIAN)
        writeInt8(mSunriseHour)
        writeInt8(mSunrisMinute)
        writeInt8(mSunrisSecond)
        writeInt8(mSunsetHour)
        writeInt8(mSunsetMinute)
        writeInt8(mSunsetSecond)
        writeInt24(0)//保留
    }
    
    func dictionaryToObjct(_ dic:[String:Any]) ->BleWeather2{
        
        let newModel = BleWeather2()
        if dic.keys.isEmpty {
            return newModel
        }
        newModel.mCurrentTemperature = dic["mCurrentTemperature"] as? Int ?? 0
        newModel.mMaxTemperature = dic["mMaxTemperature"] as? Int ?? 0
        newModel.mMinTemperature = dic["mMinTemperature"] as? Int ?? 0
        newModel.mWeatherCode = dic["mWeatherCode"] as? Int ?? 0
        newModel.mWindSpeed = dic["mWindSpeed"] as? Int ?? 0
        newModel.mHumidity = dic["mHumidity"] as? Int ?? 0
        newModel.mVisibility = dic["mVisibility"] as? Int ?? 0
        newModel.mUltraVioletIntensity = dic["mUltraVioletIntensity"] as? Int ?? 0
        newModel.mPrecipitation = dic["mPrecipitation"] as? Int ?? 0
        newModel.mSunriseHour = dic["mSunriseHour"] as? Int ?? 0
        newModel.mSunrisMinute = dic["mSunrisMinute"] as? Int ?? 0
        newModel.mSunrisSecond = dic["mSunrisSecond"] as? Int ?? 0
        newModel.mSunsetHour = dic["mSunsetHour"] as? Int ?? 0
        newModel.mSunsetMinute = dic["mSunsetMinute"] as? Int ?? 0
        newModel.mSunsetSecond = dic["mSunsetSecond"] as? Int ?? 0
                
        return newModel
    }

    override var description: String {
        return "BleWeather2(mCurrentTemperature=\(mCurrentTemperature), mMaxTemperature=\(mMaxTemperature), " +
            "mMinTemperature=\(mMinTemperature), mWeatherCode=\(mWeatherCode), mWindSpeed=\(mWindSpeed), " +
            "mHumidity=\(mHumidity), mVisibility=\(mVisibility), mUltraVioletIntensity=\(mUltraVioletIntensity), " +
            "mPrecipitation=\(mPrecipitation), mSunriseHour=\(mSunriseHour), mSunrisMinute=\(mSunrisMinute), mSunrisSecond=\(mSunrisSecond), " +
                "mSunsetHour=\(mSunsetHour), mSunsetMinute=\(mSunsetMinute), mSunsetSecond=\(mSunsetSecond))"
    }
}
