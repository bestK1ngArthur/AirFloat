//
//  DacpClient.swift
//  AirFlow-swift
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

    weak var delegate: DacpClientDelegate?
    
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
}
