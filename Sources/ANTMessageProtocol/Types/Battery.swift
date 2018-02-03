//
//  Battery.swift
//  AntMessageProtocol
//
//  Created by Kevin Hoogheem on 4/9/17.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

public enum BatteryStatus: UInt8 {
    case reserved       = 0
    case new            = 1
    case good           = 2
    case ok             = 3
    case low            = 4
    case critical       = 5
    case invalid        = 7
}

public extension BatteryStatus {

    public var stringValue: String {
        switch self {
        case .reserved:
            return "Reserved"
        case .new:
            return "New"
        case .good:
            return "Good"
        case .ok:
            return "Ok"
        case .low:
            return "Low"
        case .critical:
            return "Critical"
        case .invalid:
            return "Invalid"
        }
    }
}

public enum CumulativeOperatingResolution: UInt8 {
    case sixteenSecond      = 0
    case twoSecond          = 1

    public var multiplier: UInt8 {
        switch self {
        case .sixteenSecond:
            return 16
        default:
            return 2
        }
    }
}


/// Identifies the battery in system to which this battery 
/// status pertains and specifies how many batteries are 
/// available in the system.
public struct BatteryIdentifier {

    /// Number of Batteries max of 15
    fileprivate(set) public var count: UInt8

    /// Battery Identifier
    fileprivate(set) public var identifier: UInt8

    public var uint8Value: UInt8 {
        var value: UInt8 = count
        value |= UInt8(identifier) << 4

        return UInt8(value)
    }

    public init(_ value: UInt8) {
        self.count = (value & 0x0F)
        self.identifier = ((value & 0xF0) >> 4)
    }


    public init(count: UInt8, identifier: UInt8) {
        self.count = min(15, count)
        self.identifier = identifier
    }
}


public struct BatteryDescriptiveField {

    public let coarseVoltage: UInt8

    public let status: BatteryStatus

    public let resolution: CumulativeOperatingResolution

    public var uint8Value: UInt8 {
        var value: UInt8 = coarseVoltage
        value |= UInt8(status.rawValue) << 4
        value |= UInt8(resolution.rawValue) << 7

        return UInt8(value)
    }


    public init(_ value: UInt8) {
        self.coarseVoltage = (value & 0x0F)
        self.status = BatteryStatus(rawValue: ((value & 0x70) >> 4)) ?? .invalid
        self.resolution = CumulativeOperatingResolution(rawValue: ((value & 0x80) >> 7)) ?? .twoSecond
    }

    public init(coarseVoltage: UInt8, status: BatteryStatus, resolution: CumulativeOperatingResolution) {
        self.coarseVoltage = min(15, coarseVoltage)
        self.status = status
        self.resolution = resolution
    }
    
}
