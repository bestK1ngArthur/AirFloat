//
//  Helpers.swift
//  AirFloat-swift
//
//  Created by bestK1ng on 24/02/2019.
//

import Foundation
import os

// TODO: Test pointers

func bridge<T : AnyObject>(obj : T) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

func bridge<T : AnyObject>(ptr : UnsafeMutableRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

//func bridgeRetained<T : AnyObject>(obj : T) -> UnsafeRawPointer {
//    return UnsafeRawPointer(Unmanaged.passRetained(obj).toOpaque())
//}
//
//func bridgeTransfer<T : AnyObject>(ptr : UnsafeRawPointer) -> T {
//    return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
//}

func log(_ message: String) {
    os_log("%@", message)
}
