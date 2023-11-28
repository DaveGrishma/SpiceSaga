//
//  VideoPlayerViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 27/11/23.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    var urlVideo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playVideo()
    }
    
    func playVideo() {
        let videoURL = URL(string: urlVideo ?? "")
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
}
