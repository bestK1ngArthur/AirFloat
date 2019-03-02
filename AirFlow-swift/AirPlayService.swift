//
//  AirPlayService.swift
//  AirFlow-swift
//
//  Created by bestK1ng on 24/02/2019.
//

import UIKit
import MediaPlayer

struct Track {
    var title: String
    var artist: String
    var album: String
    var artwork: UIImage?
}

enum PlaybackState {
    case playing
    case stopped
    
    static func value(from state: DacpClient.State) -> PlaybackState {
        return state == .playing ? PlaybackState.playing : PlaybackState.stopped
    }
}

enum ControlsState {
    case available
    case unavailable
}

protocol AirPlayServiceUpdatable: AnyObject {
    func clientStartedRecording()
    func clientEndedRecording()
    func clientUpdatedTrack(_ track: Track)
    func clientUpdatedPlaybackState(_ state: PlaybackState)
    func clientUpdatedControlsState(_ state: ControlsState)
}

struct AirPlaySettings {
    let name: String
    let password: String
    let ignoreSourceVolume: Bool
}

class AirPlayService {

    static let standart = AirPlayService()

    weak var delegate: AirPlayServiceUpdatable?

    var currentTrack: Track?
    var raopServer: RaopServer
    
    var currentRaopSession: RaopSession?
    var currentDacpClient: DacpClient?

    var backgroundHandler = BackgroundHandler()
    
    init() {
        let settings = AirPlayService.getSettings()
        let name = (settings.name as NSString).utf8String
        let password = (settings.password as NSString).utf8String
        let ignoreSourceVolume = settings.ignoreSourceVolume
        let serverSettings = RaopServerSettings(name: name, password: password, ignore_source_volume: ignoreSourceVolume)

        // Create RAOP Server
        self.raopServer = RaopServer(settings: serverSettings)
        
        // Set background handler
        self.backgroundHandler.delegate = self
        
        // Setup music center
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.nextTrack()
            return .success
        }
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.previousTrack()
            return .success
        }
        MPRemoteCommandCenter.shared().playCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.togglePlay()
            return .success
        }
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.togglePlay()
            return .success
        }
    }
    
    func startServer() {
        log("AirPlayService: start server")
        self.raopServer.start()
    }
    
    func stopServer() {
        log("AirPlayService: stop server")
        self.raopServer.stop()
    }
    
    func startSession() {
        log("AirPlayService: start session")
        let session = RaopSession(server: raopServer)
        session.delegate = self
        self.currentRaopSession = session
    }
    
    func stopSession() {
        log("AirPlayService: stop session")
        self.currentRaopSession?.stop()
        self.currentRaopSession = nil
    }
    
    func togglePlay() {
        log("AirPlayService: toogle play")
        self.currentDacpClient?.togglePlay()
    }
    
    func nextTrack() {
        log("AirPlayService: next track")
        self.currentDacpClient?.next()
    }
    
    func previousTrack() {
        log("AirPlayService: previous track")
        self.currentDacpClient?.previous()
    }
    
    // MARK: Server Settings
    
    var settings: AirPlaySettings {
        return AirPlayService.getSettings()
    }
    
    func updateSettings(_ settings: AirPlaySettings) {
        
        guard let name = (settings.name as NSString).utf8String,
            let password = (settings.password as NSString).utf8String else {
            return
        }
        
        let serverSettings = RaopServerSettings(name: name, password: password, ignore_source_volume: settings.ignoreSourceVolume)
        raopServer.updateSettings(serverSettings)
        
        AirPlayService.saveSettings(settings)
    }
    
    static private let settingsNameKey = "settingsName"
    static private let settingsPasswordKey = "settingsPassword"
    static private let settingsSourceVolumeKey = "settingsSourceVolume"
    
    static private func getSettings() -> AirPlaySettings {
        
        let name = UserDefaults.standard.string(forKey: settingsNameKey) ?? "AirFloat"
        let password = UserDefaults.standard.string(forKey: settingsPasswordKey) ?? ""
        let ignoreSourceVolume = UserDefaults.standard.bool(forKey: settingsSourceVolumeKey)

        return AirPlaySettings(name: name, password: password, ignoreSourceVolume: ignoreSourceVolume)
    }
    
    static private func saveSettings(_ settings: AirPlaySettings) {
        
        UserDefaults.standard.set(settings.name, forKey: settingsNameKey)
        UserDefaults.standard.set(settings.password, forKey: settingsPasswordKey)
        UserDefaults.standard.set(settings.ignoreSourceVolume, forKey: settingsSourceVolumeKey)
    }
    
    // MARK: Track info updating logic
    
    private var trackInfoUpdated = false
    private var trackArtworkUpdated = false
    private var trackInfoCache: TrackInfo?
    private var trackArtworkCache: UIImage?

    private func updateTrackInfo(_ trackInfo: TrackInfo) {
        
        trackInfoCache = trackInfo
        trackInfoUpdated = true
        
        if trackArtworkUpdated {
            finishTrackUpdating()
        }
    }
    
    private func updateTrackArtwork(_ artwork: UIImage?) {
        
        trackArtworkCache = artwork
        trackArtworkUpdated = true
        
        if trackInfoUpdated {
            finishTrackUpdating()
        }
    }
    
    private func finishTrackUpdating() {
        
        if let trackInfo = trackInfoCache {
            let track = Track(title: trackInfo.title, artist: trackInfo.artist, album: trackInfo.album, artwork: trackArtworkCache)
            currentTrack = track
            
            delegate?.clientUpdatedTrack(track)
            updateMusicCenter(track: track)
        }
        
        trackInfoUpdated = false
        trackArtworkUpdated = false
        trackInfoCache = nil
        trackArtworkCache = nil
    }
}

extension AirPlayService: RaopSessionDelegate {
 
    func clientStartedRecording(_ session: RaopSession) {
        log("AirPlayService: clientStartedRecording")
        
        currentDacpClient = DacpClient(session: session)
        currentDacpClient?.delegate = self
        
        delegate?.clientStartedRecording()
    }
    
    func clientEndedRecording(_ session: RaopSession) {
        log("AirPlayService: clientEndedRecording")
        
//        currentDacpClient?.stop()
//        currentDacpClient = nil
        
        delegate?.clientEndedRecording()
    }
    
    func clientUpdatedArtwork(_ session: RaopSession, artwork: UIImage?) {
        log("AirPlayService: clientUpdatedArtwork")
        updateTrackArtwork(artwork)
    }
    
    func clientUpdatedTrackInfo(_ session: RaopSession, trackInfo: TrackInfo) {
        log("AirPlayService: clientUpdatedTrackInfo")
        updateTrackInfo(trackInfo)
    }
    
    func clientEnded(_ session: RaopSession) {
        log("AirPlayService: clientEnded")
    }
}

extension AirPlayService: DacpClientDelegate {
    
    func dacpClientControlsBecameAvailable(_ client: DacpClient) {
        log("AirPlayService: dacpClientControlsBecameAvailable")
    }
    
    func dacpClientPlaybackStateUpdated(_ client: DacpClient) {
        log("AirPlayService: dacpClientPlaybackStateUpdated")

        updateMusicCenterState()
        
        let playbackState = PlaybackState.value(from: client.state)
        delegate?.clientUpdatedPlaybackState(playbackState)
    }
    
    func dacpClientControlsBecameUnavailable(_ client: DacpClient) {
        log("AirPlayService: dacpClientControlsBecameUnavailable")
    }
}

// MARK: Now Playing Center

extension AirPlayService {
        
    private func updateMusicCenter(track: Track) {
        
        guard currentDacpClient?.state == .playing else {
            return
        }
        
        var playingInfo: [String : Any] = [
            MPMediaItemPropertyTitle: track.title,
            MPMediaItemPropertyArtist: track.artist,
            MPMediaItemPropertyAlbumTitle: track.album,
        ]
        
        if let artwork = track.artwork {
            playingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artwork.size, requestHandler: { _ in
                artwork
            })
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = playingInfo
    }
    
    private func updateMusicCenterState() {
        var playingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        
        let isPlaying = currentDacpClient?.state == .playing
        playingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: isPlaying ? 1.0 : 0.0)

        MPNowPlayingInfoCenter.default().nowPlayingInfo = playingInfo
    }
}

// MARK: Background mode

extension AirPlayService: BackgroundHandlerDelegate {
    
    func handleBackgroundTasks() {
        backgroundHandler.handleBackgroundTasks()
    }
    
    func handleForegroundTasks() {
        backgroundHandler.handleForegroundTasks()
    }
    
    func doBackgroundTask() {
//        stopServer()
        startServer()
    }
}
