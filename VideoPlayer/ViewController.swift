//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 07/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import UIKit
import MediaPlayer

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
        let moviePlayerViewController = MPMoviePlayerViewController(contentURL: url)
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange(notification:)), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: moviePlayerViewController?.moviePlayer)
        self.presentMoviePlayerViewControllerAnimated(moviePlayerViewController)
    }
    
    func playbackStateDidChange(notification:NSNotification) {
        let moviePlayer = notification.object as! MPMoviePlayerController
        switch moviePlayer.playbackState {
        case .stopped:
            //
            break
        case .playing:
            //
            break
        case .paused:
            //
            break
        case .interrupted:
            //
            break
        default:
            break
        }
    }
}

