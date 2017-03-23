//
//  VideoTableViewCell.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 21/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import UIKit

// MARK: - VideoTableViewCell

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var info: UILabel!
    class var identifier: String {
        return Constant.CellIdentifiers.videoCellIdentifier
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWithModel(model: VideoModel) {
        //thumbnail.image
        title.text = model.fileName
        if model.fileType == .directory {
            title.textColor = UIColor.gray
        } else {
            title.textColor = UIColor.black
        }
        info.text = "\(model.fileSize) mb"
    }
}
