//
//  PlayVideoDataModel.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 21/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

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
            var model = VideoModel(url: item)
            if model != nil && (model!.fileType == .videoFile || model!.fileType == .directory) {
                if (model!.fileType == .videoFile) {
                    model!.duration = "\(PlayVideoDataModel.getMediaDuration(url: (model?.url)!))"
                    model!.thumbnail = try? PlayVideoDataModel.getMediaThumbnail(url: (model?.url)!)
                } else {
                    model!.directoryContent = PlayVideoDataModel.getDirectoryContents(url: (model?.url)!)
                }
                data.append(model!)
            }
        }
        data = data.sorted(by: { $0.fileName < $1.fileName })
        delegate?.didRecieveDataUpdate(data: data)
    }
    
    static func filePath(fileName: String) -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName)
    }
    
    static func getMediaDuration(url: URL) -> Float64{
        let asset : AVURLAsset = AVURLAsset(url: url) as AVURLAsset
        let duration : CMTime = asset.duration
        return CMTimeGetSeconds(duration)/60
    }
    
    static func getMediaThumbnail(url: URL) throws -> Data {
        let asset : AVURLAsset = AVURLAsset(url: url) as AVURLAsset
        let generator = AVAssetImageGenerator(asset: asset)
        let frameTimeStart: Int64 = 3
        let frameLocation: Int32 = 1
        do {
            let cgimage: CGImage = try generator.copyCGImage(at: CMTimeMake(frameTimeStart, frameLocation), actualTime: nil)
            let image = UIImage(cgImage: cgimage)
            return UIImagePNGRepresentation(image)!
        } catch {
            throw VideoError.canotReadAsset
        }
    }
    
    static func getDirectoryContents(url: URL) -> Int? {
        let directoryContents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        let directoryContentsFiltered = directoryContents?.filter { (url: URL) -> Bool in
            let attr = try? FileManager.default.attributesOfItem(atPath: url.path)
            let fileType = attr?[FileAttributeKey.type] as! FileAttributeType
            return fileType.rawValue == FileAttributeType.typeRegular.rawValue
        }
        return directoryContentsFiltered?.count
    }
}

// MARK: - PlayVideoDataModelDelegate

protocol PlayVideoDataModelDelegate : class {
    
// class definition limits protocol adoption to class types (and not structures or enums): this is important if we want to use a weak reference to the delegate
    
    func didRecieveDataUpdate(data: [VideoModel])
    func didFailDataUpdateWithError(error: Error)
}

