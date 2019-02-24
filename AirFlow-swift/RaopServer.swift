//
//  AirPlayServer.swift
//  AirFlow-swift
//
//  Created by bestK1ng on 24/02/2019.
//

import Foundation

typealias RaopServerSettings = raop_server_settings_t
typealias RaopServerPointer = raop_server_p

/// Remote Audio Output Protocol Server
class RaopServer {

    private(set) var serverPointer: RaopServerPointer
    private(set) var settings: RaopServerSettings

    var isRunning: Bool {
        return raop_server_is_running(serverPointer)
    }
    
    init(settings: RaopServerSettings) {
        self.settings = settings
        self.serverPointer = raop_server_create(settings)
    }
    
    func start() {
        
        if raop_server_is_running(serverPointer) == false {
            
            var port: UInt16 = 5000
            while raop_server_start(serverPointer, port) == false, port < 5010 {
                port += 1
            }
        }
    }
    
    func stop() {
        raop_server_stop(serverPointer)
    }
    
    func updateSettings(_ newSettings: RaopServerSettings) {
        raop_server_set_settings(serverPointer, newSettings)
    }
}
