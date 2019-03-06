//
//  Helpers.swift
//  AirFloat-swift
//
//  Created by bestK1ng on 24/02/2019.
//

import Foundation
import os

func bridge<T : AnyObject>(obj : T) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

func bridge<T : AnyObject>(ptr : UnsafeMutableRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

func log(_ message: String) {
    os_log("%@", message)
}
