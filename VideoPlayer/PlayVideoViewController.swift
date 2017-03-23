//
//  PlayVideoViewController.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 07/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import UIKit

// MARK: PlayVideoViewController

class PlayVideoViewController: UIViewController, UITextFieldDelegate {
                
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // test url string
        textField.text = "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        playVideo(textField)
        return true
    }
        
    @IBAction func playVideo(_ sender: Any) {
        let url = URL(string: textField.text!)
        showVideo(url: url!)
    }
}
