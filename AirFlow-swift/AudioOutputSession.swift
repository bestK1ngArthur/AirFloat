//
//  AudioOutputSession.swift
//  AirFlow-swift
//
//  Created by bestK1ng on 24/02/2019.
//

import Foundation

class AudioOutputSession {

    static let current = AudioOutputSession()
    
    func start() {
        audio_output_session_start()
    }
    
    func stop() {
        audio_output_session_stop()
    }
}
