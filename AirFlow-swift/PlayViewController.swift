//
//  PlayViewController.swift
//  AirFlow-swift
//
//  Created by bestK1ng on 23/02/2019.
//

import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var artworkImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()

        AirPlayService.standart.delegate = self
        AirPlayService.standart.createSession()
    }
    
    func initUI() {
        self.artworkImageView.layer.cornerRadius = 16
    }
}

extension PlayViewController: AirPlayServiceUpdatable {
    
    func clientUpdatedTrackInfo(_ trackInfo: TrackInfo) {
        updateInfo(trackInfo: trackInfo)
    }
    
    func clientUpdatedArtwork(_ artwork: UIImage) {
        updateInfo(artwork: artwork)
    }

    private func updateInfo(trackInfo: TrackInfo? = nil, artwork: UIImage? = nil) {
        
        if let trackInfo = trackInfo {
            DispatchQueue.main.async {
                self.titleLabel.text = trackInfo.title
                self.subtitleLabel.text = trackInfo.artist
            }
        }
        
        if let artwork = artwork {
            DispatchQueue.main.async {
                self.artworkImageView.image = artwork
            }
        }
    }
}
