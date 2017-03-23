//
//  PlayVideoDataModel.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 21/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import Foundation

// MARK: - PlayVideoDataModel

class PlayVideoDataModel {
    
    weak var delegate: PlayVideoDataModelDelegate?
    
    func requestData(url: URL) {
        var directoryContents: [URL]?
        do {
            directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            setDataWithResponse(response: directoryContents!)
        } catch let error as NSError {
            delegate?.didFailDataUpdateWithError(error: error)
        }
    }
    
    private func setDataWithResponse(response: [URL]) {
        var data = [VideoModel]()
        for item in response {
            let model = VideoModel(url: item)
            if model != nil && (model!.fileType == .videoFile || model!.fileType == .directory) {
                data.append(model!)
            }
        }
        data = data.sorted(by: { $0.fileName! < $1.fileName! })
        delegate?.didRecieveDataUpdate(data: data)
    }
    
    static func filePath(fileName: String) -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName)
    }
}

// MARK: - PlayVideoDataModelDelegate

protocol PlayVideoDataModelDelegate : class {
    
// class definition limits protocol adoption to class types (and not structures or enums): this is important if we want to use a weak reference to the delegate
    
    func didRecieveDataUpdate(data: [VideoModel])
    func didFailDataUpdateWithError(error: Error)
}

