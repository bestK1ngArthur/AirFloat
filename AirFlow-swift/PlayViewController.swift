//
//  PlayViewController.swift
//  AirFlow-swift
//
//  Created by bestK1ng on 23/02/2019.
//

import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var pulseImageView: UIImageView!
    @IBOutlet weak var pulseView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()

        AirPlayService.standart.delegate = self
        AirPlayService.standart.startSession()
        
        changePlayerState(.hidden)
        startPulsation()
    }
    
    func initUI() {
        view.backgroundColor = AppTheme.current.backColor
        playerView.backgroundColor = AppTheme.current.backColor
        
        artworkImageView.layer.cornerRadius = 16
        
        titleLabel.textColor = AppTheme.current.textColor
        subtitleLabel.textColor = AppTheme.current.textColor
        
        playButton.tintColor = AppTheme.current.imageColor
        nextButton.tintColor = AppTheme.current.imageColor
        previousButton.tintColor = AppTheme.current.imageColor

        pulseImageView.tintColor = AppTheme.current.imageColor
        pulseView.backgroundColor = AppTheme.current.tintTextColor.withAlphaComponent(0.3)
        pulseView.layer.cornerRadius = pulseView.frame.height / 2
        pulseView.isHidden = true
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        AirPlayService.standart.togglePlay()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        AirPlayService.standart.nextTrack()
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        AirPlayService.standart.previousTrack()
    }
    
    enum PlayerState {
        case shown
        case hidden
    }
    
    private func changePlayerState(_ state: PlayerState) {
        
        let isHidden = state != .shown
        
        UIView.animate(withDuration: 0.3) {
            self.playerView.isHidden = isHidden
        }
        
        if isHidden {
            startPulsation()
        } else {
            finishPulsation()
        }
    }
    
    private func startPulsation() {
        pulseView.isHidden = false
        
        let scale: CGFloat = 35
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat], animations: {
            self.pulseView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
        }, completion: nil)
    }
    
    private func finishPulsation() {

        pulseView.layer.removeAllAnimations()
        pulseView.isHidden = true
    }
}

extension PlayViewController: AirPlayServiceUpdatable {
    
    func clientStartedRecording() {
        
        DispatchQueue.main.async {
            self.changePlayerState(.shown)
        }
    }
    
    func clientEndedRecording() {
        
        DispatchQueue.main.async {
            self.changePlayerState(.hidden)
        }
    }
    
    func clientUpdatedTrack(_ track: Track) {
        
        DispatchQueue.main.async {
            self.titleLabel.text = track.title
            self.subtitleLabel.text = track.artist
            self.artworkImageView.image = track.artwork
        }
    }
    
    func clientUpdatedPlaybackState(_ state: PlaybackState) {
        
        DispatchQueue.main.async {
            self.playButton.setBackgroundImage(state == .playing ? #imageLiteral(resourceName: "Pause") : #imageLiteral(resourceName: "Play"), for: [])
        }
    }
    
    func clientUpdatedControlsState(_ state: ControlsState) {

        DispatchQueue.main.async {
            let enabled = state == .available
            
            self.playButton.isEnabled = enabled
            self.nextButton.isEnabled = enabled
            self.previousButton.isEnabled = enabled
        }
    }
}