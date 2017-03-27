//
//  PlayLocalVideoViewController.swift
//  VideoPlayer
//
//  Created by Francesca Corsini on 07/03/2017.
//  Copyright © 2017 Francesca Corsini. All rights reserved.
//

import UIKit

// MARK: - PlayLocalVideoViewController

class PlayLocalVideoViewController: UITableViewController, PlayVideoDataModelDelegate {
    
    var url: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var dataArray = [[VideoModel]]() {
        didSet {
            tableView?.reloadData()
        }
    }
    var filteredDataArray = [[VideoModel]]()
    enum SectionType: Int {
        case file, folder
    }
    let dataSource = PlayVideoDataModel()
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self        
        searchController.loadViewIfNeeded() // you have to force loading the searchController because it hasn't a strong reference, this avoids a warning when deallocating the viewController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.autocapitalizationType = .none
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        clearsSelectionOnViewWillAppear = true
        dataSource.requestData(url: url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segues.openDirectorySegue {
            let directoryViewController = segue.destination as! DirectoryViewController
            let model = dataArray[(self.tableView.indexPathForSelectedRow?.section)!][(self.tableView.indexPathForSelectedRow?.row)!]
            directoryViewController.url = model.url!
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredDataArray = dataArray.filter { (array: [VideoModel]) -> Bool in
            return array.filter({ (data: VideoModel) -> Bool in
                return data.fileName!.lowercased().contains(searchText.lowercased())
            }).count > 0
        }
        tableView.reloadData()
    }
    
    // MARK: UITableViewDelegate/UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.section][indexPath.row]
        switch model.fileType {
        case .videoFile:
            showVideo(url: model.url!)
        case .directory:
            self.performSegue(withIdentifier: Constant.Segues.openDirectorySegue, sender: nil)
        default: break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && !(searchController.searchBar.text?.isEmpty)! {
            return filteredDataArray.count
        } else {
            return dataArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && !(searchController.searchBar.text?.isEmpty)! {
            return filteredDataArray[section].count
        }
        return dataArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier, for: indexPath) as? VideoTableViewCell {
            if searchController.isActive && !(searchController.searchBar.text?.isEmpty)! {
                cell.configureWithModel(model: filteredDataArray[indexPath.section][indexPath.row])
            } else {
                cell.configureWithModel(model: dataArray[indexPath.section][indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = (searchController.isActive && !(searchController.searchBar.text?.isEmpty)!) ? filteredDataArray[section][0] : dataArray[section][0]
        return (model.fileType == .videoFile ? "Videos" : "Folders")
    }

    // MARK: PlayVideoDataModelDelegate
    
    func didFailDataUpdateWithError(error: Error) {
        showInformationAlert(title: "Warning", message: "Error while reading local data: \(error.localizedDescription)")
    }
    
    func didRecieveDataUpdate(data: [VideoModel]) {
        let directoryArray = data.filter { $0.fileType == .directory}
        let videoArray = data.filter { $0.fileType == .videoFile}
        dataArray = [videoArray, directoryArray]
    }
}

// MARK: UISearchResultsUpdating

extension PlayLocalVideoViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

