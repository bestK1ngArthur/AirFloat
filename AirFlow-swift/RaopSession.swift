//
//  RaopSession.swift
//  AirFlow-swift
//
//  Created by bestK1ng on 24/02/2019.
//

import Foundation

typealias RaopSessionPointer = raop_session_p

protocol RaopSessionDelegate: AnyObject {
    func clientStartedRecording(_ session: RaopSession)
    func clientEndedRecording(_ session: RaopSession)
    func clientUpdatedArtwork(_ session: RaopSession)
    func clientUpdatedTrackInfo(_ session: RaopSession)
    func clientEnded(_ session: RaopSession)
}

/// Remote Audio Output Protocol Session
class RaopSession {

    weak var delegate: RaopSessionDelegate?

    var sessionPointer: RaopSessionPointer?
    
    init(server: RaopServer) {

        let selfPointer = bridge(obj: self)
        raop_server_set_new_session_callback(server.serverPointer, { (_, sessionPointer, context) in
            
            guard let context = context else {
                return
            }
            
            let selfObject: RaopSession = bridge(ptr: context)
            selfObject.sessionPointer = sessionPointer
            selfObject.setupDelegate()
            
        }, selfPointer)
    }
    
    func setupDelegate() {
        
        guard let session = sessionPointer else {
            return
        }
        
        let selfPointer = bridge(obj: self)
        
        raop_session_set_client_started_recording_callback(session, { (_, context) in
            
            guard let context = context else {
                return
            }
            
            let selfObject: RaopSession = bridge(ptr: context)
            selfObject.delegate?.clientStartedRecording(selfObject)
            
        }, selfPointer)
        
        raop_session_set_client_ended_recording_callback(session, { (_, context) in
            
            guard let context = context else {
                return
            }
            
            let selfObject: RaopSession = bridge(ptr: context)
            selfObject.delegate?.clientEndedRecording(selfObject)
            
        }, selfPointer)
    
        raop_session_set_client_updated_artwork_callback(session, { (_, data, dataSize, mimeType, context) in
            
            guard let context = context else {
                return
            }
            
            let selfObject: RaopSession = bridge(ptr: context)
            selfObject.delegate?.clientUpdatedArtwork(selfObject)
            
        }, selfPointer)
        
        raop_session_set_ended_callback(session, { (_, context) in
            
            guard let context = context else {
                return
            }
            
            let selfObject: RaopSession = bridge(ptr: context)
            selfObject.delegate?.clientEnded(selfObject)
            
        }, selfPointer)
    }
    
    func stop() {
        guard let session = sessionPointer else {
            return
        }
        
        raop_session_stop(session)
    }
}

