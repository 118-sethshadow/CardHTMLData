//
//  ViewController.swift
//  TCGPlayerData
//
//  Created by Kartikeya Kaushal on 9/23/14.
//  Copyright (c) 2014 K. All rights reserved.
//

import UIKit

class ResultListController: UITableViewController, UISearchBarDelegate, SearchControllerProtocol {
    
    /*components of this page are:
    Search Bar
    2 Scope Buttons
    Table View
    Name
    Image
    */
    
    var searchBar:UISearchBar = UISearchBar()
    //array to hold card objects
    var cardList: [Card] = []
    var albums: [Album] = []
    //controller for search engine
    lazy var searchEngine: SearchController = SearchController(delegate: self)
    var done = 1
    
    
    override func viewDidLoad() {
        //set the search Bar
        searchBar.delegate = self
        self.tableView.tableHeaderView = self.searchBar
        configSearchBar()
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = searchBar
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
//        if(cell == nil){
//            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
//        }
        
        let album = self.albums[indexPath.row]
        cell.textLabel?.text = album.title!
        cell.imageView?.image = UIImage(named: "Blank52")
        cell.detailTextLabel?.text = album.price!
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            
            let urlString = NSURL(string: album.thumbnailImageURL!)
            var image:UIImage?
            
            let request = NSURLRequest(URL: urlString!)
            let urlConnection = NSURLConnection(request: request, delegate: self)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    image = UIImage(data: data!)
                    
                    if let albumArtsCell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath) {
                            albumArtsCell?.imageView?.image = image!
                    }
                }
                else {
                    print("Error: \(error!.localizedDescription)")
                }
            })
            
            
            
            
            })
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            
            let urlString = NSURL(string: album.largeImageURL!)
            var image:UIImage?
            
            let request = NSURLRequest(URL: urlString!)
            let urlConnection = NSURLConnection(request: request, delegate: self)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    image = UIImage(data: data!)
                    
                    album.image = image
                }
                else {
                    print("Error: \(error!.localizedDescription)")
                }
            })
   
        })
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let album: Album = albums[indexPath.row]
        let detailView:DetailViewController = DetailViewController(albumInfo:albums[indexPath.row], imageInfo: album.image)
        self.showViewController(detailView, sender: detailView)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        albums.removeAll(keepCapacity: false)
        print("Search query is \(searchBar.text)")
        // see if we are looking for an app, or an artist
        if searchBar.selectedScopeButtonIndex == 0{
            searchEngine.searchAppStore(searchBar.text!)
        }
        else if searchBar.selectedScopeButtonIndex == 1{
            searchEngine.searchITunes(searchBar.text!)
        }
    }
    
    
    
    func configSearchBar() {
        searchBar.scopeButtonTitles = [
            NSLocalizedString("Apps + Games", comment: ""),
            NSLocalizedString("Artists", comment: "")]
        searchBar.showsScopeBar = true
        searchBar.sizeToFit()
    }
    
    
    
    func didReceiveSearchResults(results: [Album]) {
        
        albums = results
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }


}