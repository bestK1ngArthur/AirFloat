//
//  RaopSession.swift
//  AirFloat-swift
//
//  Created by bestK1ng on 24/02/2019.
//

import UIKit

typealias RaopSessionPointer = raop_session_p

struct TrackInfo {
    let title: String
    let artist: String
    let album: String
}

protocol RaopSessionDelegate: AnyObject {
    func clientStartedRecording(_ session: RaopSession)
    func clientEndedRecording(_ session: RaopSession)
    func clientUpdatedArtwork(_ session: RaopSession, artwork: UIImage?)
    func clientUpdatedTrackInfo(_ session: RaopSession, trackInfo: TrackInfo)
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
            
            guard let context = context, let data = data else {
                return
            }
            
            var artwork: UIImage?
            if strcmp(mimeType, "image/none") != 0 {
                let imageData = Data(bytes: data, count: dataSize)
                artwork = UIImage(data: imageData, scale: UIScreen.main.scale)
            }
            
            let selfObject: RaopSession = bridge(ptr: context)
            selfObject.delegate?.clientUpdatedArtwork(selfObject, artwork: artwork)
            
        }, selfPointer)
        
        raop_session_set_client_updated_track_info_callback(session, { (_, titleC, artistC, albumC, context) in
            
            guard let context = context, let titleC = titleC, let artistC = artistC, let albumC = albumC else {
                return
            }
            
            guard let title = String(cString: titleC, encoding: String.Encoding.utf8),
                let artist = String(cString: artistC, encoding: String.Encoding.utf8),
                let album = String(cString: albumC, encoding: String.Encoding.utf8) else {
                return
            }

            let trackInfo = TrackInfo(title: title, artist: artist, album: album)
            
            let selfObject: RaopSession = bridge(ptr: context)
            selfObject.delegate?.clientUpdatedTrackInfo(selfObject, trackInfo: trackInfo)
            
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

