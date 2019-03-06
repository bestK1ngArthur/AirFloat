//
//  DacpClient.swift
//  AirFloat-swift
//
//  Created by bestK1ng on 24/02/2019.
//

import Foundation

typealias DacpClientPointer = dacp_client_p

protocol DacpClientDelegate: AnyObject {
    func dacpClientControlsBecameAvailable(_ client: DacpClient)
    func dacpClientPlaybackStateUpdated(_ client: DacpClient)
    func dacpClientControlsBecameUnavailable(_ client: DacpClient)
}

/// Digital Audio Control Protocol Client
class DacpClient {

    enum State: Int {
        case stopped = 2
        case paused
        case playing
    }
    
    weak var delegate: DacpClientDelegate?
    
    var state: State {
        return State(rawValue: Int(dacp_client_get_playback_state(clientPointer).rawValue)) ?? .stopped
    }
    
    private var clientPointer: DacpClientPointer
    
    init(session: RaopSession) {
        self.clientPointer = raop_session_get_dacp_client(session.sessionPointer)
        self.setupDelegate()
    }
    
    private func setupDelegate() {
        
        let selfPointer = bridge(obj: self)

        dacp_client_set_controls_became_available_callback(clientPointer, { (_, context) in
            
            guard let context = context else {
                return
            }
            
            let selfObject: DacpClient = bridge(ptr: context)
            selfObject.delegate?.dacpClientControlsBecameAvailable(selfObject)
            
        }, selfPointer)
        
        dacp_client_set_playback_state_changed_callback(clientPointer, { (_, state, context) in
            
            guard let context = context else {
                return
            }
            
            let selfObject: DacpClient = bridge(ptr: context)
            selfObject.delegate?.dacpClientPlaybackStateUpdated(selfObject)
            
        }, selfPointer)
        
        dacp_client_set_controls_became_unavailable_callback(clientPointer, { (_, context) in
            
            guard let context = context else {
                return
            }
            
            let selfObject: DacpClient = bridge(ptr: context)
            selfObject.delegate?.dacpClientControlsBecameUnavailable(selfObject)
            
        }, selfPointer)
    }
    
    func stop() {
        dacp_client_stop(clientPointer)
    }
    
    func togglePlay() {
        dacp_client_toggle_playback(clientPointer)
    }
    
    func next() {
        dacp_client_next(clientPointer)
    }
    
    func previous() {
        dacp_client_previous(clientPointer)
    }
    
    func seek(seconds: Float) {
        dacp_client_seek(clientPointer, seconds)
    }
    
    func setVolume(_ volume: Float) {
        dacp_client_set_volume(clientPointer, volume)
    }
}
