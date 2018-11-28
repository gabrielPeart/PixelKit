//
//  LiveFloat.swift
//  Pixels
//
//  Created by Hexagons on 2018-11-23.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat {
    init(_ liveFloat: LiveFloat) {
        self = liveFloat.value
    }
}
extension Float {
    init(_ liveFloat: LiveFloat) {
        self = Float(liveFloat.value)
    }
}
extension Double {
    init(_ liveFloat: LiveFloat) {
        self = Double(liveFloat.value)
    }
}
//extension Int {
//    init(_ liveFloat: LiveFloat) {
//        self = Int(liveFloat.value)
//    }
//}

public class LiveFloat: LiveValue, /*Equatable, Comparable,*/ ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, CustomStringConvertible/*, BinaryFloatingPoint */ {
    
    public var description: String {
        return "live(\(CGFloat(self)))"
    }
    
    var futureValue: () -> (CGFloat)
    var value: CGFloat {
        return futureValue()
    }
    
    var uniform: CGFloat {
        get {
            uniformCache = CGFloat(self)
            return CGFloat(self)
        }
    }
    var uniformIsNew: Bool {
        return uniformCache != CGFloat(self)
    }
    var uniformCache: CGFloat? = nil
    
    
    //    public var year: LiveFloat!
    //    public var month: LiveFloat!
    //    public var day: LiveFloat!
    //    public var hour: LiveFloat!
    //    public var minute: LiveFloat!
    //    public var second: LiveFloat!
    public static var seconds: LiveFloat {
        return LiveFloat({ () -> (CGFloat) in
            return Pixels.main.seconds
        })
    }
    public static var secondsSince1970: LiveFloat {
        return LiveFloat({ () -> (CGFloat) in
            return CGFloat(Date().timeIntervalSince1970)
        })
    }
    
    
    public init(_ futureValue: @escaping () -> (CGFloat)) {
        self.futureValue = futureValue
    }
    
    public init(_ liveInt: LiveInt) {
        futureValue = { return CGFloat(Int(liveInt)) }
    }
    
    public init(frozen value: CGFloat) {
        futureValue = { return CGFloat(value) }
    }
    
    required public init(floatLiteral value: FloatLiteralType) {
        futureValue = { return CGFloat(value) }
    }
    
    required public init(integerLiteral value: IntegerLiteralType) {
        futureValue = { return CGFloat(value) }
    }
    
//    enum CodingKeys: String, CodingKey {
//        case rawValue; case liveKey
//    }
    
//    func filter(for seconds: LiveFloat) -> LiveFloat {
//        // ...
//    }
    
    // MARK: Equatable
    
    public static func == (lhs: LiveFloat, rhs: LiveFloat) -> LiveBool {
        return LiveBool({ return CGFloat(lhs) == CGFloat(rhs) })
    }
    public static func != (lhs: LiveFloat, rhs: LiveFloat) -> LiveBool {
        return !(lhs == rhs)
    }
//    public static func == (lhs: LiveFloat, rhs: CGFloat) -> LiveBool {
//        return lhs.value == rhs
//    }
//    public static func == (lhs: CGFloat, rhs: LiveFloat) -> LiveBool {
//        return lhs == rhs.value
//    }
    
    // MARK: Comparable
    
    public static func < (lhs: LiveFloat, rhs: LiveFloat) -> LiveBool {
        return LiveBool({ return CGFloat(lhs) < CGFloat(rhs) })
    }
    public static func <= (lhs: LiveFloat, rhs: LiveFloat) -> LiveBool {
        return LiveBool({ return CGFloat(lhs) <= CGFloat(rhs) })
    }
    public static func > (lhs: LiveFloat, rhs: LiveFloat) -> LiveBool {
        return LiveBool({ return CGFloat(lhs) > CGFloat(rhs) })
    }
    public static func >= (lhs: LiveFloat, rhs: LiveFloat) -> LiveBool {
        return LiveBool({ return CGFloat(lhs) >= CGFloat(rhs) })
    }
//    public static func < (lhs: LiveFloat, rhs: CGFloat) -> LiveBool {
//        return LiveFloat({ return lhs.value < rhs })
//    }
//    public static func < (lhs: CGFloat, rhs: LiveFloat) -> LiveBool {
//        return LiveFloat({ return lhs < rhs.value })
//    }
    
    // MARK: Operators
    
    public static func + (lhs: LiveFloat, rhs: LiveFloat) -> LiveFloat {
        return LiveFloat({ return CGFloat(lhs) + CGFloat(rhs) })
    }
    public static func += (lhs: inout LiveFloat, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LiveFloat({ return CGFloat(_lhs) + CGFloat(rhs) })
    }
    
    public static func - (lhs: LiveFloat, rhs: LiveFloat) -> LiveFloat {
        return LiveFloat({ return CGFloat(lhs) - CGFloat(rhs) })
    }
    public static func -= (lhs: inout LiveFloat, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LiveFloat({ return CGFloat(_lhs) - CGFloat(rhs) })
    }
    
    
    public static func * (lhs: LiveFloat, rhs: LiveFloat) -> LiveFloat {
        return LiveFloat({ return CGFloat(lhs) * CGFloat(rhs) })
    }
    public static func *= (lhs: inout LiveFloat, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LiveFloat({ return CGFloat(_lhs) * CGFloat(rhs) })
    }
    
    public static func / (lhs: LiveFloat, rhs: LiveFloat) -> LiveFloat {
        return LiveFloat({ return CGFloat(lhs) / CGFloat(rhs) })
    }
    public static func /= (lhs: inout LiveFloat, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LiveFloat({ return CGFloat(_lhs) / CGFloat(rhs) })
    }
    
    
    public static func ** (lhs: LiveFloat, rhs: LiveFloat) -> LiveFloat {
        return LiveFloat({ return pow(CGFloat(lhs), CGFloat(rhs)) })
    }
    
    public static func !** (lhs: LiveFloat, rhs: LiveFloat) -> LiveFloat {
        return LiveFloat({ return pow(CGFloat(lhs), 1.0 / CGFloat(rhs)) })
    }
    
    public static func % (lhs: LiveFloat, rhs: LiveFloat) -> LiveFloat {
        return LiveFloat({ return CGFloat(lhs).truncatingRemainder(dividingBy: CGFloat(rhs)) })
    }
    
    
    public static func <> (lhs: LiveFloat, rhs: LiveFloat) -> LiveFloat {
        return LiveFloat({ return min(CGFloat(lhs), CGFloat(rhs)) })
    }
    
    public static func >< (lhs: LiveFloat, rhs: LiveFloat) -> LiveFloat {
        return LiveFloat({ return max(CGFloat(lhs), CGFloat(rhs)) })
    }
    
    
    public prefix static func - (operand: LiveFloat) -> LiveFloat {
        return LiveFloat({ return -CGFloat(operand) })
    }
    
    public prefix static func ! (operand: LiveFloat) -> LiveFloat {
        return LiveFloat({ return 1.0 - CGFloat(operand) })
    }
    
    
    public static func <=> (lhs: LiveFloat, rhs: LiveFloat) -> (LiveFloat, LiveFloat) {
        return (lhs, rhs)
    }
    
    // MARK: Local Funcs
    
    public func truncatingRemainder(dividingBy other: LiveFloat) -> LiveFloat {
        return LiveFloat({ return CGFloat(self).truncatingRemainder(dividingBy: CGFloat(other)) })
    }

    public func remainder(dividingBy other: LiveFloat) -> LiveFloat {
        return LiveFloat({ return CGFloat(self).remainder(dividingBy: CGFloat(other)) })
    }
    
}


// MARK: Global Funcs

public func round(_ live: LiveFloat) -> LiveFloat {
    return LiveFloat({ return round(CGFloat(live)) })
}
public func floor(_ live: LiveFloat) -> LiveFloat {
    return LiveFloat({ return floor(CGFloat(live)) })
}
public func ceil(_ live: LiveFloat) -> LiveFloat {
    return LiveFloat({ return ceil(CGFloat(live)) })
}

public func sqrt(_ live: LiveFloat) -> LiveFloat {
    return LiveFloat({ return sqrt(CGFloat(live)) })
}
public func pow(_ live: LiveFloat, _ live2: LiveFloat) -> LiveFloat {
    return LiveFloat({ return pow(CGFloat(live), CGFloat(live2)) })
}

public func cos(_ live: LiveFloat) -> LiveFloat {
    return LiveFloat({ return cos(CGFloat(live)) })
}
public func sin(_ live: LiveFloat) -> LiveFloat {
    return LiveFloat({ return sin(CGFloat(live)) })
}
public func atan(_ live: LiveFloat) -> LiveFloat {
    return LiveFloat({ return atan(CGFloat(live)) })
}
public func atan2(_ live: LiveFloat, _ live2: LiveFloat) -> LiveFloat {
    return LiveFloat({ return atan2(CGFloat(live), CGFloat(live2)) })
}

// MARK: New Global Funcs

public func deg(rad live: LiveFloat) -> LiveFloat {
    return LiveFloat({ return (CGFloat(live) / .pi / 2.0) * 360.0 })
}
public func rad(deg live: LiveFloat) -> LiveFloat {
    return LiveFloat({ return (CGFloat(live) / 360.0) * .pi * 2.0 })
}