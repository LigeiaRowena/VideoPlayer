//
//  PlayVideoViewController.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 07/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import UIKit
import MediaPlayer

// MARK: PlayVideoViewController

class PlayVideoViewController: UIViewController, UITextFieldDelegate {
                
    @IBOutlet weak var textField: UITextField!
    
    // MARK: Init/launch viewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // test url string
        textField.text = "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v"
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        playVideo(textField)
        return true
    }
    
    // MARK: Actions
    
    @IBAction func playVideo(_ sender: Any) {
        let url: NSURL = NSURL(string: textField.text!)!
        let moviePlayerViewController = MPMoviePlayerViewController(contentURL: url as URL!)
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange(notification:)), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: moviePlayerViewController?.moviePlayer)
        self.presentMoviePlayerViewControllerAnimated(moviePlayerViewController)
    }
    
    // MARK: MPMoviePlayerViewController private methods
    
    func playbackStateDidChange(notification:NSNotification) {
        let moviePlayer = notification.object as! MPMoviePlayerController
        switch moviePlayer.playbackState {
        case MPMoviePlaybackState.stopped:
            //
            break
        case MPMoviePlaybackState.playing:
            //
            break
        case MPMoviePlaybackState.paused:
            //
            break
        case MPMoviePlaybackState.interrupted:
            //
            break
        default:
            break
        }
    }
}
