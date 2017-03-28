//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 07/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import AVKit

// MARK: ViewController

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UIViewController {
    
    func showInformationAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler:{ (action:UIAlertAction) -> Void in
        })
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
    }
    
    func showVideo(url: URL) {
        
        if #available(iOS 9, *) {
            // Use AVPlayer​View​Controller
            let playerItem = AVPlayerItem(url: url)
            let player = AVPlayer(playerItem: playerItem)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            //NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
            
        } else {
            // Use MPMoviePlayerViewController
            let moviePlayerViewController = MPMoviePlayerViewController(contentURL: url)
            //NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange(notification:)), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: moviePlayerViewController?.moviePlayer)
            self.presentMoviePlayerViewControllerAnimated(moviePlayerViewController)
        }
    }
    
    func finishedPlaying(notification: NSNotification) {
        print("video ended")
    }
    
    func playbackStateDidChange(notification:NSNotification) {
        let moviePlayer = notification.object as! MPMoviePlayerController
        switch moviePlayer.playbackState {
        case .stopped:
            print("video stopped")
            break
        case .playing:
            print("video playing")
            break
        case .paused:
            print("video paused")
            break
        case .interrupted:
            print("video interrupted")
            break
        default:
            break
        }
    }
}

