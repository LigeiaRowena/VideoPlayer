//
//  DirectoryViewController.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 24/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import UIKit

// MARK: - DirectoryViewController

class DirectoryViewController: PlayLocalVideoViewController {
    
    override func didRecieveDataUpdate(data: [VideoModel]) {
        let videoArray = data.filter { $0.fileType == .videoFile}
        dataArray = [videoArray]
    }
}

