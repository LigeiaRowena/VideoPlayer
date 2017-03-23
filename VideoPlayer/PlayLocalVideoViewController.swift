//
//  PlayLocalVideoViewController.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 07/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import UIKit

// MARK: - PlayLocalVideoViewController

class PlayLocalVideoViewController: UIViewController, PlayVideoDataModelDelegate {
    
    var url: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var dataArray = [VideoModel]() {
        didSet {
            tableView?.reloadData()
        }
    }
    let dataSource = PlayVideoDataModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.requestData(url: url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segues.openDirectorySegue {
            let directoryViewController = segue.destination as! DirectoryViewController
            let model = dataArray[(self.tableView.indexPathForSelectedRow?.row)!]
            directoryViewController.url = model.url!
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    // MARK: PlayVideoDataModelDelegate
    
    func didFailDataUpdateWithError(error: Error) {
        showInformationAlert(title: "Warning", message: "Error while reading local data: \(error.localizedDescription)")
    }
    
    func didRecieveDataUpdate(data: [VideoModel]) {
        dataArray = data
    }
}

// MARK: UITableViewDelegate

extension PlayLocalVideoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        switch model.fileType {
        case .videoFile:
            showVideo(url: model.url!)
        case .directory:
            self.performSegue(withIdentifier: Constant.Segues.openDirectorySegue, sender: nil)
        default: break
        }
    }
}

// MARK: UITableViewDataSource

extension PlayLocalVideoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier, for: indexPath) as? VideoTableViewCell {
            cell.configureWithModel(model: dataArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

class DirectoryViewController: PlayLocalVideoViewController {
    
    // MARK: UITableViewDelegate/UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        switch model.fileType {
        case .videoFile:
            showVideo(url: model.url!)
        case .directory:
            showInformationAlert(title: "Warning", message: "No valid video file")
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier, for: indexPath) as? VideoTableViewCell {
            cell.configureWithModel(model: dataArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
    override func didRecieveDataUpdate(data: [VideoModel]) {
        dataArray = data.filter { (model: VideoModel) -> Bool in
            return model.fileType == .videoFile
        }
    }
}

