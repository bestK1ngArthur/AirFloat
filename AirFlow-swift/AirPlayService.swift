//
//  AirPlayService.swift
//  AirFlow-swift
//
//  Created by bestK1ng on 24/02/2019.
//

import Foundation

class AirPlayService {

    static let standart = AirPlayService()

    var raopServer: RaopServer
    var currentRaopSession: RaopSession?
    
    init() {
        let emptyString = ("" as NSString).utf8String
        let settings = RaopServerSettings(name: emptyString, password: emptyString, ignore_source_volume: false)
        
        self.raopServer = RaopServer(settings: settings)
    }
    
    func startServer() {
        self.raopServer.start()
    }
    
    func stopServer() {
        self.raopServer.stop()
    }
    
    func createSession() -> RaopSession {
        
        let session = RaopSession(server: raopServer)
        self.currentRaopSession = session
        
        return session
    }
    
    func removeSession() {
        self.currentRaopSession?.stop()
        self.currentRaopSession = nil
    }
}
