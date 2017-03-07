//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 07/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import UIKit

// MARK: ViewController

class ViewController: UIViewController, UIActionSheetDelegate {
    
    //playLocalVideo
    //playVideo
    
    // MARK: Init/launch viewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions

    @IBAction func playVideoSelected(_ sender: Any) {
        let alertController = UIAlertController(title: "Choose Option", message: "", preferredStyle: .alert)
        let urlPlayAction = UIAlertAction(title: "Play video from URL", style: .default, handler: {
            Void in
            self.performSegue(withIdentifier: Constant.Segues.playVideoSegue, sender: nil)
        })
        let localPlayAction = UIAlertAction(title: "Play local video", style: .default, handler: {
            Void in
            self.performSegue(withIdentifier: Constant.Segues.playLocalVideoSegue, sender: nil)
        })
        alertController.addAction(urlPlayAction)
        alertController.addAction(localPlayAction)
        present(alertController, animated: true, completion: nil)
    }
}

