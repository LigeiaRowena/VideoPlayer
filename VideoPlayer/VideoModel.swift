//
//  Model.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 10/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import Foundation

// MARK: - VideoModel

struct VideoModel {
    enum FileType {
        case videoFile, noVideoFile, directory, unknown
    }
    enum LoadingError: Error {
        case noFile
        case cannotReadFile
    }
    var duration: String?
    var fileName: String?
    var url: URL?
    var fileExtension: String?
    var fileType: FileType
    var creationDate: Date?
    var fileSize: UInt64
    
    init?(url: URL?) {
        if (url != nil) {
            self.fileName = url!.deletingPathExtension().lastPathComponent
            self.url = url
            self.fileExtension = url!.pathExtension
            self.fileType = .unknown
            self.fileSize = 0
            try! fileAttributes(url: url!)
        } else {
            return nil
        }
    }
    
    mutating func fileAttributes(url: URL) throws  {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            self.creationDate = attr[FileAttributeKey.creationDate] as? Date
            self.fileSize = (attr[FileAttributeKey.size] as! UInt64)/(1024*1024)
            let fileType = attr[FileAttributeKey.type] as! FileAttributeType
            if fileType.rawValue == FileAttributeType.typeRegular.rawValue {
                if Constant.Paths.videoExtensions.contains(url.pathExtension) {
                    self.fileType = .videoFile
                } else {
                    self.fileType = .noVideoFile
                }
            } else if fileType.rawValue == FileAttributeType.typeDirectory.rawValue {
                self.fileType = .directory
            }
        } catch {
            self.fileType = .unknown
            throw LoadingError.cannotReadFile
        }
    }
}

