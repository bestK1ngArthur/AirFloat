//
//  AirPlayService.swift
//  AirFlow-swift
//
//  Created by bestK1ng on 24/02/2019.
//

import UIKit

protocol AirPlayServiceUpdatable: AnyObject {
    func clientUpdatedTrackInfo(_ trackInfo: TrackInfo)
    func clientUpdatedArtwork(_ artwork: UIImage)
}

class AirPlayService {

    static let standart = AirPlayService()

    weak var delegate: AirPlayServiceUpdatable?
    
    var raopServer: RaopServer
    var currentRaopSession: RaopSession?
    var currentDacpClient: DacpClient?

    init() {
        let emptyString = ("" as NSString).utf8String
        let settings = RaopServerSettings(name: emptyString, password: emptyString, ignore_source_volume: false)
        
        self.raopServer = RaopServer(settings: settings)
    }
    
    func startServer() {
        print("AirPlayService: start server")
        self.raopServer.start()
    }
    
    func stopServer() {
        self.raopServer.stop()
    }
    
    func createSession() {
        
        print("AirPlayService: create session")
        
        let session = RaopSession(server: raopServer)
        session.delegate = self
        self.currentRaopSession = session

//        let client = DacpClient(session: session)
//        client.delegate = self
//        self.currentDacpClient = client
    }
    
    func removeSession() {
        self.currentRaopSession?.stop()
        self.currentRaopSession = nil
    }
}

extension AirPlayService: RaopSessionDelegate {
 
    func clientStartedRecording(_ session: RaopSession) {
        print("AirPlayService: clientStartedRecording")
    }
    
    func clientEndedRecording(_ session: RaopSession) {
        print("AirPlayService: clientEndedRecording")
    }
    
    func clientUpdatedArtwork(_ session: RaopSession, artwork: UIImage?) {
        print("AirPlayService: clientUpdatedArtwork")
        
        if let artwork = artwork {
            delegate?.clientUpdatedArtwork(artwork)
        }
    }
    
    func clientUpdatedTrackInfo(_ session: RaopSession, trackInfo: TrackInfo) {
        print("AirPlayService: clientUpdatedTrackInfo")
        delegate?.clientUpdatedTrackInfo(trackInfo)
    }
    
    func clientEnded(_ session: RaopSession) {
        print("AirPlayService: clientEnded")
    }
}

extension AirPlayService: DacpClientDelegate {
    
    func dacpClientControlsBecameAvailable(_ client: DacpClient) {
        print("AirPlayService: dacpClientControlsBecameAvailable")
    }
    
    func dacpClientPlaybackStateUpdated(_ client: DacpClient) {
        print("AirPlayService: dacpClientPlaybackStateUpdated")
    }
    
    func dacpClientControlsBecameUnavailable(_ client: DacpClient) {
        print("AirPlayService: dacpClientControlsBecameUnavailable")
    }
}
