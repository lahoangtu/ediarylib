//
// Created by Best Mafen on 2019/9/24.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

// BLE协议中的command
enum BleCommand: Int, CaseIterable {
    case UPDATE = 0x01, SET = 0x02, CONNECT = 0x03, PUSH = 0x04, DATA = 0x05, CONTROL = 0x06, IO = 0x07,
         NONE = 0xff

    var mDisplayName: String {
        String(format: "0x%02X_", rawValue) + "\(self)"
    }

    // 获取该command对应的所有key
    func getBleKeys() -> [BleKey] {
        BleKey.allCases.filter { bleKey in
            print("测试数据:\(bleKey)")
            if bleKey == .BODY_DATA {
            }
            return bleKey.mCommandRawValue == rawValue
        }
    }
}

/**
 * BLE协议中的key, key的定义包括了其对应的command，使用时直接使用key就行了
 * 增加key时，需要同步修改BleCache.requireCache()、BleCache.getIdObjects()、BleKey.isIdObjectKey()
 */
enum BleKey: Int, CaseIterable {
    // UPDATE
    case OTA = 0x0101, XMODEM = 0x0102

    // SET
    case TIME = 0x0201, TIME_ZONE = 0x0202, POWER = 0x0203, FIRMWARE_VERSION = 0x0204,
         BLE_ADDRESS = 0x0205, USER_PROFILE = 0x0206, STEP_GOAL = 0x0207, BACK_LIGHT = 0x0208,
         SEDENTARINESS = 0x0209, NO_DISTURB_RANGE = 0x020A, VIBRATION = 0x020B,
         GESTURE_WAKE = 0x020C, HR_ASSIST_SLEEP = 0x020D, HOUR_SYSTEM = 0x020E, LANGUAGE = 0x020F,
         ALARM = 0x0210
    /// 单位设置, 公制英制设置 0: 公制  1: 英制
    case UNIT_SETTIMG = 0x0211
    case COACHING = 0x0212,
         FIND_PHONE = 0x0213, NOTIFICATION_REMINDER = 0x0214, ANTI_LOST = 0x0215, HR_MONITORING = 0x0216,
         UI_PACK_VERSION = 0x0217, LANGUAGE_PACK_VERSION = 0x0218, SLEEP_QUALITY = 0x0219, DRINKWATER = 0x0221 , HEALTH_CARE = 0x021A,
         TEMPERATURE_DETECTING = 0x021B, AEROBIC_EXERCISE = 0x021C, TEMPERATURE_UNIT = 0x021D, DATE_FORMAT = 0x021E,
         WATCH_FACE_SWITCH = 0x021F, AGPS_PREREQUISITE = 0x0220,APP_SPORT_DATA = 0x0223, REAL_TIME_HEART_RATE = 0x0224,BLOOD_OXYGEN_SET = 0x0225, WASH_SET = 0x0226, REAL_TIME_TEMPERATURE = 0x0230,REAL_TIME_BLOOD_PRESSURE = 0x0231,
//         Temperature
         // KeyFlag为UPDATE时：设备支持外置多表盘，但是因为IO协议的限制，无法携带表盘id信息，所以在发送表盘文件之前需要先发送该指令提前告知
         //                    将要发送表盘的id
         // KeyFlag为READ时：设备支持外置多表盘，读取设备上已存在表盘id列表
         WATCHFACE_ID = 0x0227,
         IBEACON_SET = 0x0228,
         MAC_QRCODE = 0x0229,
         /// 温度标定, 手机下发当前温度标定值至设备端
         TEMPERATURE_VALUE = 0x0232,
         GAME_SET = 0x0233,
         FIND_WATCH = 0x0234,
         SET_WATCH_PASSWORD = 0x0235,
         REALTIME_MEASUREMENT = 0x0236,
         /// 省电模式
         POWER_SAVE_MODE = 0x0237,
         /// 酒精浓度检测设置
         BAC_SET = 0x0238,
         REALTIME_LOG = 0x02F9,
         GSENSOR_OUTPUT = 0x02FA, // G-Sensor原始数据，1开启，0关闭
         GSENSOR_RAW = 0x02FB, // G-Sensor原始数据，2^9为1g
         MOTION_DETECT = 0x02FC, // G-Sensor动作检测数据，n组√(x1 - x0)² + (y1 - y0)² + (z1 - z0)²，带符号16位整数
         LOCATION_GGA = 0x02FD, // 设备定位GGA数据
         RAW_SLEEP = 0x02FE,
         NO_DISTURB_GLOBAL = 0x02FF
    // Set
    /// 卡路里目标设置
    case CALORIES_GOAL = 0x0239
    /// 卡路里目标设置
    case DISTANCE_GOAL = 0x023A
    /// 睡眠目标设置
    case SLEEP_GOAL = 0x023B
    /// 发送LoveTap 消息
    case LOVE_TAP = 0x0608
    /// LoveTap 联系人
    case LOVE_TAP_USER = 0x023C
    /// 吃药提醒设置
    case MEDICATION_ERMINDER = 0x023D
    /// 精简的设备信息
    case DEVICE_INFO2 = 0x023E
    /// 推送, Newsfeed 消息
    case NEWS_FEER = 0x040B
    /// 心率警报设置
    case Heart_Rate_Alarm = 0x023F
    /// 睡眠检测时间段
    case SLEEP_DETECTION_PERIOC = 0x0240
    /// 待机设置,  待机表盘
    case STANDBY_SETTING = 0x0241
    

    // CONNECT
    case IDENTITY = 0x0301, // 身份，代表绑定的意思
         SESSION = 0x0302, // 会话，代表登陆的意思
         PAIR = 0x0303 // 配对
    case THIRD_PARTY_DATA = 0x0609 // 第三方应用的通信

    // PUSH
    case MUSIC_CONTROL = 0x0402, SCHEDULE = 0x0403
    /// 推送实时天气
    case WEATHER_REALTIME = 0x0404
    /// 推送预报天气
    case WEATHER_FORECAST = 0x0405
    /// 推送实时天气 2
    case WEATHER_REALTIME2 = 0x040C
    /// 推送预报天气 2
    case WEATHER_FORECAST2 = 0x040D
    /// 在线天数
    case ONLINE_DAYS = 0x040E
         
    case WORLD_CLOCK = 0x0407,
         STOCK = 0x0408,
         // 推送快捷回复内容. 安卓实现, iOS无需实现
         SMS_QUICK_REPLY_CONTENT = 0x0409,
         /// 推送消息(带有电话号码).  安卓实现, iOS无需实现
         NOTIFICATION2 = 0x040A

    // DATA
    case DATA_ALL = 0x05ff, // 实际协议中并没有该指令，该指令只是用来同步所有数据 0x050C 固件原始数据,用于固件分析使用,保存到text文件即可
         ACTIVITY_REALTIME = 0x0501,
         ACTIVITY = 0x0502, HEART_RATE = 0x0503, BLOOD_PRESSURE = 0x0504, SLEEP = 0x0505,
         WORKOUT = 0x0506, LOCATION = 0x0507, TEMPERATURE = 0x0508, BLOODOXYGEN = 0x0509,
         BLOOD_GLUCOSE = 0x0510,  /// 血糖指令
         HRV = 0x050A, LOG = 0x050B, SLEEP_RAW_DATA = 0x050C, PRESSURE = 0x050D,WORKOUT2 = 0x050E,MATCH_RECORD = 0x050F
    case BODY_DATA = 0x0511, FEELING_DATA = 0x0512

    // CONTROL
    case CAMERA = 0x0601, PHONE_GPSSPORT = 0x0602, APP_SPORT_STATE = 0x0604,IBEACON_CONTROL = 0x0606, DEVICE_SMS_QUICK_REPLY = 0x0607

    // IO
    case WATCH_FACE = 0x0701
    case AGPS_FILE = 0x0702
    case FONT_FILE = 0x0703
    case CONTACT = 0x0704
    case UI_FILE = 0x0705
    case MEDIA_FILE = 0x0706
    case LANGUAGE_FILE = 0x0707
    /// BrandInfo传输协议(关联蓝牙名和logo)
    case BRAND_INFO_FILE = 0x0708
    // 发送二维码到设备
    case QRCode = 0x0709

    case NONE = 0xffff

    var mDisplayName: String {
        String(format: "0x%04X_", rawValue) + "\(self)"
    }

    var mBleCommand: BleCommand {
        if let command = BleCommand(rawValue: (rawValue >> 8) & 0xff) {
            return command
        } else {
            return BleCommand.NONE
        }
    }

    var mCommandRawValue: UInt8 {
        UInt8((rawValue >> 8) & 0xff)
    }

    var mKeyRawValue: UInt8 {
        UInt8(rawValue & 0xff)
    }

    func getBleKeyFlags() -> [BleKeyFlag] {
        switch self {
            // UPDATE
        case .OTA, .XMODEM:
            return [.UPDATE]
            // SET
        case .POWER, .FIRMWARE_VERSION, .BLE_ADDRESS, .UI_PACK_VERSION, .LANGUAGE_PACK_VERSION:
            return [.READ]
        case .NOTIFICATION_REMINDER, .SLEEP_QUALITY, .HEALTH_CARE, .TEMPERATURE_DETECTING, .APP_SPORT_DATA, .REAL_TIME_HEART_RATE,.BLOOD_OXYGEN_SET,.WASH_SET,.GAME_SET,.SET_WATCH_PASSWORD,.REALTIME_MEASUREMENT, .TEMPERATURE_VALUE, .STANDBY_SETTING:
            return [.UPDATE]
        case .GESTURE_WAKE: // 抬手亮屏
            return [.UPDATE] // 这个指令, 是可以接受设备的回调的, 设备设置抬手亮屏后, 会告诉APP设置的数据
        case .TIME, .TIME_ZONE, .USER_PROFILE, .STEP_GOAL, .BACK_LIGHT, .SEDENTARINESS,
             .NO_DISTURB_RANGE, .WATCH_FACE_SWITCH, .NO_DISTURB_GLOBAL, .AEROBIC_EXERCISE, .VIBRATION, .HR_ASSIST_SLEEP, .TEMPERATURE_UNIT, .DATE_FORMAT,
             .HOUR_SYSTEM, .LANGUAGE, .ANTI_LOST, .HR_MONITORING , .DRINKWATER, .WATCHFACE_ID,.IBEACON_SET,.MAC_QRCODE:
            return [.UPDATE, .READ]
        case .RAW_SLEEP:
            return [.READ]
        case .ALARM:
            return [.CREATE, .DELETE, .UPDATE, .READ, .RESET]
        case .COACHING:
            return [.CREATE, .UPDATE, .READ]
            // CONNECT
        case .IDENTITY, .DEVICE_SMS_QUICK_REPLY:
            return [.CREATE, .READ, .DELETE]
        case .PAIR:
            return [.UPDATE]
            // PUSH
        case .SCHEDULE:
            return [.CREATE, .DELETE, .UPDATE]
        case .WEATHER_REALTIME, .WEATHER_FORECAST, .ONLINE_DAYS:
            return [.UPDATE]
        case .WORLD_CLOCK, .STOCK:
            return [.CREATE,.READ,.DELETE]
            // DATA
        case .DATA_ALL, .ACTIVITY_REALTIME:
            return [.READ]
        case .ACTIVITY, .HEART_RATE, .BLOOD_PRESSURE, .SLEEP, .WORKOUT, .LOCATION, .TEMPERATURE, .BLOODOXYGEN, .HRV, .SLEEP_RAW_DATA, .PRESSURE, .WORKOUT2, .MATCH_RECORD, .BLOOD_GLUCOSE:
            return [.READ, .DELETE]
        case .BODY_DATA, .FEELING_DATA:
            return [.READ]
            
            // CONTROL
        case .CAMERA, .APP_SPORT_STATE,.IBEACON_CONTROL:
            return [.UPDATE]
            // IO
        case .CONTACT:
            return [.UPDATE, .DELETE]
        case .WATCH_FACE, .AGPS_FILE, .FONT_FILE, .UI_FILE, .LANGUAGE_FILE, .BRAND_INFO_FILE, .QRCode:
            return [.UPDATE]
        case .POWER_SAVE_MODE: // 省电模式
            return [.UPDATE, .READ]
        case .BAC_SET: // 酒精浓度检测设置
            return [.UPDATE]
        default:
            return []
        }
    }

    func isIdObjectKey() -> Bool {
        self == .ALARM || self == .SCHEDULE || self == .COACHING || self == .WORLD_CLOCK || self == .STOCK
    }
}

enum BleKeyFlag: Int {
    case UPDATE = 0x00, READ = 0x10, READ_CONTINUE = 0x11, CREATE = 0x20, DELETE = 0x30,
         // BleIdObject专属，相当于Delete All和Create的组合，用于绑定时重置BleIdObject列表
         // 只能用BleConnector.sendArray重置，sendObject无效
         RESET = 0x40,
         NONE = 0xff

    var mDisplayName: String {
        String(format: "0x%02X_", rawValue) + "\(self)"
    }
}
