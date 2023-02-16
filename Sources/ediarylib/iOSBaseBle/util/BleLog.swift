//
// Created by Best Mafen on 2019/9/27.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

// 只有DEBUG为true时才会打印日志
var BASE_BLE_DEBUG = true
let kRuntimeBleLog = "kRuntimeBleLog"

func bleLog(_ message: String) {
    #if DEBUG
    let dateFormat1 = DateFormatter()
    dateFormat1.dateFormat = "YYYY-MM-dd HH:mm:ss"
    print("\(Thread.current) - \(dateFormat1.string(from: Date()))-\(Date().milliStamp)  \(message)")
    #else
    
    // write log (.text) SDK 仅实现空的方法即可, 不报错即可, 这个日志方法主要为我们APP提供信息输出而已, 没什么特殊, 但是SDK为客户自己使用, 尽量不要做日志留存, 保护客户APP的私密性
    // en: write log (.text) SDK can only realize the empty method, no error can be reported, this log method mainly provides information output for our APP, nothing special, but SDK for the customer's own use, try not to do log retention, to protect the privacy of the customer APP
    /**
     // 空方法的示例 en: Example of an empty method
     class ABHBleLog: NSObject {
         static let share = ABHBleLog()
         
         func startWriteMessage(_ message: String) {
             
         }
     }
     */
    if UserDefaults.standard.bool(forKey: kRuntimeBleLog) {
        ABHBleLog.share.startWriteMessage(message)
    }
    #endif
}

extension Date {
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        let milli :String = "\(millisecond)"
        return String(milli.suffix(4)) as String
    }
}
