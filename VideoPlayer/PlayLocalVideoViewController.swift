//
//  PlayLocalVideoViewController.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 07/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import UIKit
import MediaPlayer

// MARK: PlayLocalVideoViewController

class PlayLocalVideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    var data: [String]!
    
    // MARK: Init/launch viewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        data = documentsContent()
    }
    
    // MARK: I/O methods
    
    func filePath(fileName: String) -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName)
    }
    
    func documentsContent() -> [String]! {
        var directoryContents: [String]!
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            directoryContents = try FileManager.default.contentsOfDirectory(atPath: documentsPath)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return directoryContents.sorted(){ $0 < $1 }
    }
    
    // MARK: UITableViewDataSource/UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let file = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifiers.videoCellIdentifier) ?? UITableViewCell(style: .`default`, reuseIdentifier: Constant.CellIdentifiers.videoCellIdentifier)
        cell.textLabel?.text = file
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = filePath(fileName: data[indexPath.row])
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
